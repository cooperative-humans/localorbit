module ProductUpload
	include Imports
	class ProcessProductUploadJob  < Struct.new(:datafile, :curr_user, :upload_audit_id) # pass in the datafile like is done right now in uploadcontroller, i.e.
		# :Imports::SerializeProducts.get_json_data(params[:datafile],params[:curr_user])
		
		def enqueue(job)
			job.delayed_reference_id = upload_audit_id
			job.delayed_reference_type = 'ProductUpload' # ??
			job.save!
		end

		def success(job)
			update_status('success')
		end

		# TODO really necessary?
		def error(job, exception)
			update_status("There was an error, please try again")
			# Send any other alert? Where should this go? TODO
		end

		def failure(job)
      update_status('failure')
    end

    # helper methods to process things go here

    def perform
    	# this is the method that should so something
    	# TODO maybe others here shoudl change too since this job isn't just processing stuff

    	# this is where the actual uploading should go in the controller n stuff

    	# this is taken from the upload controller -- it's what should happen here
    	jsn = ::Imports::SerializeProducts.get_json_data(datafile,curr_user)

    	unless jsn.include?("invalid")
        jsn[0]["products"].each do |p|
          ::Imports::ProductHelpers.create_product_from_hash(p,params[:curr_user])
          @num_products_loaded += 1
          if p.has_key?("Multiple Pack Sizes") && !p["Multiple Pack Sizes"].empty?
            @num_products_loaded += 1
          end
        end
        @errors = jsn[1]
        aud.update_attributes(audited_changes: "#{@num_products_loaded} products updated (or maintained)",associated_type:current_market.subdomain.to_s,comment:"#{User.find(current_user.id).email}") 
      else
        @num_products_loaded = 0
        @errors = {"File"=>jsn}
      end
    end


		private

		def check_and_update_status
			upload = Audit.find(upload_audit_id) # this is probably not actually what to do though
			# check the audit for it being completed or something

			raise StandardError.new("Your upload is not complete") unless upload.status == 'new' # is new a default thing or should this happen elsewhere with update_status
			job.status = 'processing'
			job.save!
		end

		def update_status(status)
			job = Audit.find(upload_audit_id)
			job.status = status
			job.save!
    end

	end
end