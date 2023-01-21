module Visible extend ActiveSupport::Concern

	VALID_STATUS = ['public', 'private', 'archived']

	included do
		validates :status, inclusion: { in: VALID_STATUS }
	end

	class_methods do
		def public_count
			where(status: 'public').count
		end
	end

	def archived?
		status == 'archived'
	end
end