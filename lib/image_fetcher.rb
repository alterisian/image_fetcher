require 'down'

class ImageFetcherError < StandardError
  def initialize(msg="Image Fetcher Error", exception_type="custom")
    @exception_type = exception_type
    super(msg)
  end
end

class ImageFetcher
  attr_reader :image_urls_filename, :image_urls, :error_count

  def initialize(image_urls_filename)
    if image_urls_filename.nil? or !File.exists? image_urls_filename
      raise ArgumentError.new "Error: Please pass an image file with full path into the constructor."
    end
    @error_count = 0
    puts "Initialising with: #{image_urls_filename}"
    @image_urls_filename = image_urls_filename
  end

  def go
    load_image_urls_filename
    clear_output_directory
    download_images
  end

  def clear_output_directory
    output_dir = "./output"
    FileUtils.rm Dir.glob("#{output_dir}/*")
  end

  def load_image_urls_filename
    rval = ""

    begin
      file = File.open @image_urls_filename
      rval = "File: #{@image_urls_filename} opened"

      @image_urls = file.readlines.map(&:chomp)

      rval = "File: #{@image_urls_filename} contains #{@image_urls.length} urls"

      if @image_urls.length > 0
        puts "Number of image urls = " + @image_urls.length.to_s
        rval = "ok"
      end

    rescue Errno::ENOENT => file_exception
      rval = "#{@image_urls_filename} \n is not a valid file. Try another filename?"
      #todo: re-raise application exception?
    end   

    rval
  end

  def download_images
    if @image_urls.nil? or @image_urls.empty? 
      raise ImageFetcherError.new "Error: Please call load_image_urls_filename first"
      rval = "ImageFetcherError"      
    end

    puts "We will retrieve #{@image_urls.count} images"

    @image_urls.each do |image_url|
      puts "downloading #{image_url}"
      begin
        tempfile = Down.download(image_url)
        FileUtils.mv(tempfile.path, "./output/#{tempfile.original_filename}")
      rescue Down::NotFound
        @error_count += 1
        puts "Error: Down::NotFound - unable to download #{image_url}"
      rescue Down::ConnectionError
        @error_count += 1
        puts "Error: Down::ConnectionError - unable to download #{image_url}"
      end
    end

    rval
  end
end