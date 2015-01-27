class ImageWorker
  include Sidekiq::Worker

	def perform(image,dir)
		if item = Item.where(:id => image['item_id']).first
			if item.image.size != 0
				@md5_exist = Digest::MD5.hexdigest(File.read("#{Rails.root}/public#{item.image}"))
				@md5_new = Digest::MD5.hexdigest(File.read("#{dir}/#{image['file']}"))
				@cr = true if @md5_exist == @md5_new
			end
			unless @cr
			item.image = File.open("#{dir}/#{image['file']}")
			puts "save image"
				if item.save
					while not FileTest.exist?("#{Rails.root}/public#{item.image.item.url}")
					puts "#{item.title} recreate versions!"
					item.image.recreate_versions!
					end
				end
			end
		end
	end
end

