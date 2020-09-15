require_relative '../lib/image_fetcher.rb'

RSpec.describe ImageFetcher do
  let(:image_urls_filename) { "./input/image_list.txt" }
  let(:image_fetcher) { ImageFetcher.new image_urls_filename }
  
  it "should initialise the filename to open" do    
    expect(image_fetcher.image_urls_filename).to eq(image_urls_filename)
  end

  it "should raise an exception with a message if no image file is given" do
    expect{ImageFetcher.new}.to raise_error(ArgumentError)
  end

  it "should give an appropiate error message if an invalid file path is given" do
    wrong_image_urls_filename = "../this_directory_is_wrong_too/this_is_clearly_a_wrong_filename.txt"
    
    expect{ImageFetcher.new wrong_image_urls_filename}.to raise_error(ArgumentError)
  end

  it "should have more than 1 entry in the image url list" do
    image_fetcher.load_image_urls_filename

    expect(image_fetcher.image_urls.count).to be > 1
  end

  it "should open the file with a list of images" do   
    expect(image_fetcher.load_image_urls_filename).to eq("ok")
  end

  context "starting with an empty output directory" do
    let(:output_dir) {"./output"}
    before do 
      FileUtils.rm Dir.glob("#{output_dir}/*") # empty the output directory
    end

    it "should have the same number of lines in input file as the number of files in the output directory" do    
      image_urls_filename = "./input/image_list.txt"
      image_fetcher = ImageFetcher.new image_urls_filename
      image_fetcher.load_image_urls_filename
      num_files_to_download = image_fetcher.image_urls.count

      image_fetcher.download_images

      directory_listing_after = Dir.entries output_dir
      adjusted_number_files_in_directory = directory_listing_after.count - 2 # is . and ..
      # then also reduce by the number of errors.
      num_files_to_download -= image_fetcher.error_count

      expect(num_files_to_download).to eq adjusted_number_files_in_directory    
    end

    it "should raise an exception if the fetch_images method is caused with no image_urls populated from the load_files method" do
      pending("understand why exception isnt being caught in rspec")
      image_urls_filename = "./input/image_list.txt"
      image_fetcher = ImageFetcher.new image_urls_filename
      expect(image_fetcher.download_images).to raise_error(ImageFetcherException, "Error: Please call load_image_urls_filename first")
    end
  end
end