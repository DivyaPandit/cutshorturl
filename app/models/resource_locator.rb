require 'autoinc'
class ResourceLocator
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Autoinc

  field :given_url, type: String
  field :mini_url,  type: String
  field :clicks , type: Integer , default: 0
  field :resource_locator_id, type: Integer

  default_scope -> { desc(:clicks)}
  validates :given_url , presence: true, uniqueness: true
  validates :mini_url, uniqueness: true
  validates_format_of :given_url, :with => URI::regexp(%w(http https))

  before_create :create_short_url
  increments :resource_locator_id , seed: 1000

  # adding index for resource_locator_id
  index(resource_locator_id: 1)

  # Public method to view slug along with BASE_URL
  # 
  # returns url to display with mini url
  #
  def view_mini_url
   SHORT_API_URL + self.mini_url
  end

  #
  # Public method to convert mini url to resource_locator_id
  #
  def self.decode_mini_url(mini_url)
    id = 0
    base = CHARACTER_SET.length
    # dividend = divisor × quotient + remainder
    # 0 is first quotient always
    mini_url.each_char { |c| id = id * base + (CHARACTER_SET.index(c).nil? ? CHARACTER_SET.index(c.to_i) : CHARACTER_SET.index(c) ) }
    id = id / 100000
    id
  end

  private
  # Private method to create slug/mini_url for given url in before_create callback
  # 
  # set mini url to callback object
  #
  def create_short_url
    mini_url = ''
    base = CHARACTER_SET.length
    id = self.resource_locator_id
    id = id * 100000
    # converting in base 32
    while  id > 0
      mini_url += CHARACTER_SET[id.modulo(base)].to_s
      id = id / base
    end
    self.mini_url = mini_url.reverse
  end
end
