module SessionsHelper
	def isLogined()
		session[:user] != nil
	end

end
