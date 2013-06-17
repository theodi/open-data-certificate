class Dependency < ActiveRecord::Base
  unloadable
  include Surveyor::Models::DependencyMethods


  def is_met?(response_set, responses_pre = nil)
    ch = conditions_hash(response_set, responses_pre)
    return false if ch.blank?
    # logger.debug "rule: #{self.rule.inspect}"
    # logger.debug "rexp: #{rgx.inspect}"
    # logger.debug "keyp: #{ch.inspect}"
    # logger.debug "subd: #{self.rule.gsub(rgx){|m| ch[m.to_sym]}}"
    rgx = Regexp.new(self.dependency_conditions.map{|dc| ["a","o"].include?(dc.rule_key) ? "\\b#{dc.rule_key}(?!nd|r)\\b" : "\\b#{dc.rule_key}\\b"}.join("|")) # exclude and, or
    eval(self.rule.gsub(rgx){|m| ch[m.to_sym]})
  end

  # A hash of the conditions (keyed by rule_key) and their evaluation (boolean) in the context of response_set
  def conditions_hash(response_set, responses_pre = nil)
    hash = {}
    self.dependency_conditions.each{|dc| hash.merge!(dc.to_hash(response_set, responses_pre))}
    return hash
  end

end
