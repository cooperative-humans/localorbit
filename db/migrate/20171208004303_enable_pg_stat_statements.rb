class EnablePgStatStatements < ActiveRecord::Migration
  def change
    enable_extension 'pg_stat_statements' unless extension_enabled?('pg_stat_statements')
  end
end
