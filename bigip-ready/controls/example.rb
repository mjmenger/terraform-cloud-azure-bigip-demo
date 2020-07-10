# copyright: 2018, The Authors

# run all of the tests
require_controls 'big-ip-atc-ready' do
  control 'bigip-connectivity'
  control 'bigip-cve-2020-5902'
end
