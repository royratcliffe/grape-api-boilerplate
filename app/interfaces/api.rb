require 'grape'

class API < Grape::API
  # Accept application/hal+json content only.
  content_type :hal, 'application/hal+json'
  formatter :hal, Grape::Formatter::SerializableHash

  # Automatically mount APIs. No need to know what APIs exist in advance. The
  # super-API supports many, dynamically. The APIs can be Git-hosted sub-modules
  # cloned under the app/interfaces directory. Look for api.rb files in all the
  # app/interfaces subfolders. Mount the API at a mount point corresponding to
  # its sub-directory path.
  ActiveSupport::Dependencies.autoload_paths.each do |interfaces_dir|
    Dir[File.join(interfaces_dir, '*', 'api.rb')].each do |api_rb|
      relative_api_rb = Pathname.new(api_rb).relative_path_from(Pathname.new(interfaces_dir)).to_path
      path = relative_api_rb.split(File::SEPARATOR)[0...-1].join(File::SEPARATOR)
      mount "#{path}::API".camelize.constantize => File.join(File::SEPARATOR, path)
    end
  end

  get do
    { _links: { self: { href: request.url } } }
  end
end
