Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :twitter, 'rCpzJTK92RiMe75KNXacQ', 'CHu0HWARPpaJFzaTg47U387mYFcRcYPKChC97QH5g'
  provider :twitter, 'Msaz5aB2EZWjA8LJoOuWPQ', 'TC1sATa0vworlTXT0LPmoZWFwoI9r4aSkvcWa41b25I'
  #localhost  facebook credentials
  #provider :facebook, '305179209528609', 'bb50b9fc56195684033544a378ccf470', {:scope => 'publish_stream,offline_access,email'}
  # ilsainteractive:3003 facebook credentials
  provider :facebook, '289702534420217', '216c3c3baf4e3301e3d0cfb992b810ca', {:scope => 'publish_stream,offline_access,email'}
end