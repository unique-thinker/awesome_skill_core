module CountriesWithStates
  # def countries_with_states(region='Asia', locale = 'en')
  #   countries_with_states = []
  #   ISO3166::Country.find_all_countries_by_region(region).map do |c|
  #     h = {}
  #     h[c.name] = c.alpha2
  #     countries_with_states.push({
  #       country: h,
  #       states: c.subdivision_names_with_codes.to_h
  #     })
  #   end.sort
  #   countries_with_states
  # end

  def country_with_states(country_code='IN')
    country_with_states = {}
    country = Country.find_all_countries_by_alpha2(country_code)
    country.map do |c|
      h = {}
      h[c.name] = {
        id: c.alpha2,
        states: c.subdivision_names_with_codes.map {|s| {name: s[0]}}
      }
      country_with_states.merge!(h)
    end.sort
    country_with_states
  end
end