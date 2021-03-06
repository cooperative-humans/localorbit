
class ProductImport::Transforms::AliasKeys < ProductImport::Framework::Transform
  def transform_step(row)
    opts[:key_map].each do |original, aliased|
      if row.key?(original) && !(opts[:skip_if_present] && row[aliased].present?)
        row[aliased] = row[original]
      end
    end
    continue row
  end
end
