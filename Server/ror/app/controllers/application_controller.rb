$s1024 = 'A' * 1024
$s2048 = 'A' * 2048
$s4096 = 'A' * 4096
$s8192 = 'A' * 8192

class ApplicationController < ActionController::API
	def empty
		render plain: ''
	end
	def s1024
		render plain: $s1024
	end
	def s2048
		render plain: $s2048
	end
	def s4096
		render plain: $s4096
	end
	def s8192
		render plain: $s8192
	end
	def getArgs2048
		('a'..'z').each do |n|
			f = params['abc' + n]
			puts String(f)
		end
		render plain: $s2048
	end
	def postArgs2048
		('a'..'z').each do |n|
			f = params['abc' + n]
			puts String(f)
		end
		render plain: $s2048
	end
	def postArgsMulti2048
		('a'..'z').each do |n|
			f = params['abc' + n]
			puts String(f)
		end
		render plain: $s2048
	end
end
