require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module LanguageSpecHelper

end
                                                              
describe Language do

  include LanguageSpecHelper

  before(:each) do
    @site = Site.new(:name => "Sample site")
    @site.languages.build(:name => I18n.default_locale, :locale => I18n.default_locale)
    @language = @site.languages.first
  end

  it "should be valid" do
    @language.should be_valid
  end

  it "should require a name" do
    @language.name = ""
    @language.should_not be_valid
  end

  it "should require a locale" do
    @language.locale = ""
    @language.should_not be_valid
  end

  it "should validate the locale" do
    @language.locale = "noonexistinglocale"
    @language.should_not be_valid
  end
  
  it "should be a valid locale" do
    I18n.available_locales.should be_include @language.locale.to_sym
  end
  
end