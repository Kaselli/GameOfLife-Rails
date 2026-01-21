
require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # 'headless_chrome' is required for GitHub Actions to pass
  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1400 ]
end
