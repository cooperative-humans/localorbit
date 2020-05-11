

module ProductImport::Schemas


  CANONICAL = RSchema.schema {{ #
    'product_code' => maybe(either(Integer,String)),
    'name' => String,

    'category' => %r{^([a-z,/0-9&_ -]*>)*[a-z,/0-9&_ -]*$}i,
    # e.g. Grandparent > Parent > Brothers & Sisters

    'price' => predicate("valid price"){|p| p && p.to_f > 0},
    'contrived_key' => String,
    # e.g. 12.34

    'unit' => either(Integer,String),
    optional('uom') => String,

    optional('unit_description') => maybe(String),
    optional('short_description') => String,
    optional('long_description') => String,
    optional('organization') => String,
    optional('break_case') => String,
    optional('source_data') => Hash,
  }}


  # Everything in canonical pluss database ids for required fields
  RESOLVED_CANONICAL = CANONICAL.merge(
    'organization_id' => Integer,
    'market_id' => Integer,
    'category_id' => Integer,
  )
end
