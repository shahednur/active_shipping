require 'test_helper'

class CanadaPostPwsTest < ActiveSupport::TestCase

  def setup
    credentials = { platform_id: 123, api_key: '456', secret: '789' }
    @cp = CanadaPostPWS.new(credentials)
  end

  def test_get_sanitized_postal_code_location_nil
    location = nil

    postal_code = @cp.send(:get_sanitized_postal_code, location)

    assert_equal nil, postal_code
  end

  def test_get_sanitized_postal_code_postal_code_nil
    location_params = { name: 'Test test' }
    location = Location.new(location_params)

    assert_equal nil, location.postal_code

    postal_code = @cp.send(:get_sanitized_postal_code, location)

    assert_equal nil, postal_code
  end

  def test_get_sanitized_postal_code_spaces
    location_params = { postal_code: '    K2P     1L4    '}
    location = Location.new(location_params)

    postal_code = @cp.send(:get_sanitized_postal_code, location)

    assert_equal 'K2P1L4', postal_code
  end

  def test_get_sanitized_postal_code_lowercase
    location_params = { postal_code: 'k2p 1l4'}
    location = Location.new(location_params)

    postal_code = @cp.send(:get_sanitized_postal_code, location)

    assert_equal 'K2P1L4', postal_code
  end

  def test_get_sanitzied_postal_code_proper
    location_params = { postal_code: 'K2P1l4'}
    location = Location.new(location_params)

    postal_code = @cp.send(:get_sanitized_postal_code, location)

    assert_equal 'K2P1L4', postal_code
  end

  def test_get_sanitzied_postal_code_does_not_alter_original
    location_params = { postal_code: 'K2P  1l4'}
    location = Location.new(location_params)

    assert_equal 'K2P  1l4', location.postal_code

    @cp.send(:get_sanitized_postal_code, location)

    assert_equal 'K2P  1l4', location.postal_code
  end
end
