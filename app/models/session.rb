require 'bcrypt'

class Session < ActiveRecord::Base
	def password
		@password ||= BCrypt::Password.new(self.password_digest)
	end

	def password=(newPassword)
		@password = BCrypt::Password.create(newPassword)
		self.password_digest = @password
	end


end
