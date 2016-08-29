module ApplicationHelper
	def current_user
		@current_user ||= Session.find_by user:session[:user]
	end

	def loged_in
		!current_user.nil?
	end
	
	def zeroToO(datetime) 
		datetime.to_s.gsub(/[^0-9]/, "").gsub(/0/, "o")
	end
end
