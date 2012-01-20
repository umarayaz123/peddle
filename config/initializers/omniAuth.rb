Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :twitter, 'rCpzJTK92RiMe75KNXacQ', 'CHu0HWARPpaJFzaTg47U387mYFcRcYPKChC97QH5g'
  provider :twitter, 'Msaz5aB2EZWjA8LJoOuWPQ', 'TC1sATa0vworlTXT0LPmoZWFwoI9r4aSkvcWa41b25I'
  provider :facebook, '305179209528609', 'bb50b9fc56195684033544a378ccf470'
end