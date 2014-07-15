Recaptcha.configure do |config|
	config.public_key	= RECAP_CONFIG['public']
	config.private_key	= RECAP_CONFIG['private']
end
