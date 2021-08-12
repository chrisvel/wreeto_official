class RailsAdminPgArray < RailsAdmin::Config::Fields::Base
  register_instance_option :formatted_value do
    value.join(',')
  end
end

class RailsAdminPgStringArray < RailsAdminPgArray
  def parse_input(params)
    if params[name].is_a?(::String)
      params[name] = params[name].split(',')
    end
  end
end

class RailsAdminPgIntArray < RailsAdminPgArray
  def parse_input(params)
    if params[name].is_a?(::String)
      params[name] = params[name].split(',').collect{|x| x.to_i}
    end
  end
end

RailsAdmin::Config::Fields::Types::register(:pg_string_array, RailsAdminPgStringArray)
RailsAdmin::Config::Fields::Types::register(:pg_int_array, RailsAdminPgIntArray)