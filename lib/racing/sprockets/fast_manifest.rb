require 'thread_safe'
require 'sprockets/manifest'
require 'thread/pool'

Sprockets::Manifest.class_eval do
  def assets
    @data['assets'] = ThreadSafe::Hash.new(@data['assets'] || {})
  end

  def files
    @data['files'] = ThreadSafe::Hash.new(@data['files'] || {})
  end

  def compile(*args)
    unless environment
      raise Error, "manifest requires environment for compilation"
    end

    paths = environment.each_logical_path(*args).to_a +
      args.flatten.select { |fn| Pathname.new(fn).absolute? if fn.is_a?(String)}

    thread_pool = Thread.pool(10)

    paths.each do |path|
      thread_pool.process do
        if asset = find_asset(path)
          files[asset.digest_path] = {
            'logical_path' => asset.logical_path,
            'mtime'        => asset.mtime.iso8601,
            'size'         => asset.bytesize,
            'digest'       => asset.digest
          }
          assets[asset.logical_path] = asset.digest_path

          target = File.join(dir, asset.digest_path)

          if File.exist?(target)
            logger.debug "Skipping #{target}, already exists"
          else
            logger.info "Writing #{target}"
            asset.write_to target
            asset.write_to "#{target}.gz" if asset.is_a?(Sprockets::BundledAsset)
          end
        end
      end
    end
    thread_pool.wait_done

    save
    paths
  end
end
