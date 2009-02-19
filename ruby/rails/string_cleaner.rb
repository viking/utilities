# makes AR models turn empty strings to nil before validation
module StringCleaner
  module ClassMethods
    def string_columns
      @string_columns ||= columns.inject([]) do |ary, column|
        ary << column.name if [:string, :text].include?(column.type)
        ary
      end
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
    base.before_validation :clean_strings
  end

  private
    def clean_strings
      self.class.string_columns.each do |name|
        @attributes[name] = nil   if @attributes[name].blank?
      end
    end
end
