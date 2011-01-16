
class EmailDomainValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    good = false
    EmailDomain.all.each do |domain|
      if value.match(Regexp.new(".*?@.*?" + domain.rule + "*?"))
        good = true
        break
      end
    end
    object.errors[attribute] << (options[:message] || "You can only signup if you have an allowed email address.") unless good
  end
end