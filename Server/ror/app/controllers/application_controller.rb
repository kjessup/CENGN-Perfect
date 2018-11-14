
$s2048 = 'A' * 2048
$s8192 = 'A' * 8192
$s32768 = 'A' * 32768

class ApplicationController < ActionController::API
	def empty
		render plain: ''
	end
	def s2048
		render plain: $s2048
	end
	def s8192
		render plain: $s8192
	end
	def s32768
		render plain: $s32768
	end
	def getArgs2048
		('a'..'z').each do |n|
			f = params['abc' + n]
			#puts String(f)
		end
		render plain: $s2048
	end
	def postArgs2048
		('a'..'z').each do |n|
			f = params['abc' + n]
			#puts String(f)
		end
		render plain: $s2048
	end
	def postArgsMulti2048
		('a'..'z').each do |n|
			f = params['abc' + n]
			#puts String(f)
		end
		render plain: $s2048
	end
	def json
		render json: params['application']
	end
end
