module Enumerate
  module Model
    def enumerate(attribute, vals={}, opts={})

      validates_inclusion_of attribute, :in => vals, :allow_nil => !!opts[:allow_nil]
      
      # Get the column type of the attribute. We support int and string
      col_type = self.columns_hash[attribute.to_s].type
      
      const_hash_name = attribute.to_s.pluralize.upcase
    
      if col_type == :string
        vals = Hash[vals.zip vals.map{ |s| s.to_s }] if vals.kind_of?(Array)
      elsif col_type == :integer
        # Converts an array into a hash of values with indicies as the "values"
        vals = Hash[vals.zip (0...vals.size)] if vals.kind_of?(Array)
      else
        raise "Unsupported column type for enumeration :#{attribute} in #{self.class}!"
      end
      
      # Ensure that only arrays and hashes are appropriate datatypes.
      raise "Unsupported values datatype for enumeration :#{attribute} in #{self.class}!" if !vals.kind_of?(Hash)
      
      # Sets a class costant with the enumerated values
      const_set(const_hash_name, vals)
      
      setup_accessors(const_hash_name, attribute)

      setup_predicates(vals, attribute)

    end

    private
    
      def setup_accessors(const_hash_name, attribute)
        unless methods.include?(attribute.to_s)
          self.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{attribute.to_s}
              #{const_hash_name}.key(read_attribute(:#{attribute}))
            end
          RUBY
        end
      
        unless methods.include?("#{attribute.to_s}=")
          self.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{attribute.to_s}=(s)
              write_attribute(:#{attribute}, #{const_hash_name}[s.to_sym])
            end
          RUBY
        end
      end

      def setup_predicates(vals, attribute)
          vals.each do |key, val|
              raise "Collision in enumeration predicate method(s) #{key}" if respond_to?("#{key.to_s}?") or respond_to?("#{key.to_s}!") or respond_to?("#{key.to_s}")
              
              define_method "#{key.to_s}?" do
                send("#{attribute.to_s}") == key
              end
              
              define_method "#{key.to_s}!" do
                send("#{attribute.to_s}=", key)
              end
              
              # Define helper scopes
              self.class_eval <<-RUBY, __FILE__, __LINE__ + 1
                scope :#{key}, lambda { where(:#{attribute} => #{val}) }
              RUBY
          end
      end

  end

end
