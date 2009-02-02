require 'rubygems'
require 'sinatra'
require 'json'
require 'dm-core'
require 'dm-serializer'

DataMapper.setup(:default, "mysql://root@localhost/smt")
repository(:default).adapter.field_naming_convention = lambda { |value| value.name.to_s }

class Catalog
  include DataMapper::Resource
  storage_names[:default] = 'Catalogs'

  property :id,                    String, :field => 'CATALOGID',:serial => true
  property :name,                  String, :field => 'NAME'
  property :description,           String, :field => 'DESCRIPTION'
  property :target,                String, :field => 'TARGET'
  property :localpath,             String, :field => 'LOCALPATH'
  property :exthost,               String, :field => 'EXTHOST'
  property :exturl,                String, :field => 'EXTURL'
  property :domirror,              String, :field => 'DOMIRROR'
  property :mirrorable,            String, :field => 'MIRRORABLE'
  property :src,                   String, :field => 'SRC'
end

class Product
  include DataMapper::Resource
  storage_names[:default] = 'Products'

  property :id,                    Serial, :field => 'PRODUCTDATAID',:key => true
  property :name,                  String, :field => 'PRODUCT'
  property :version,               String, :field => 'VERSION'
  property :release,               String, :field => 'REL'
  property :arch,                  String, :field => 'ARCH'
  property :productlower,          String, :field => 'PRODUCTLOWER'
  property :versionlower,          String, :field => 'VERSIONLOWER'
  property :rellower,              String, :field => 'RELLOWER'
  property :archlower,             String, :field => 'ARCHLOWER'
  property :friendly,              String, :field => 'FRIENDLY'
  property :paramlist,             String, :field => 'PARAMLIST'
  property :needinfo,              String, :field => 'NEEDINFO'
  property :service,               String, :field => 'SERVICE'
  property :product_list,          String, :field => 'PRODUCT_LIST'
  property :product_class,         String, :field => 'PRODUCT_CLASS'
  property :src,                   String, :field => 'SRC'

  has n, :registrations, :child_key => [:PRODUCTID]
end

class Registration
  include DataMapper::Resource
  storage_names[:default] = 'Registration'

  property :client_id,             String, :field => 'GUID', :key => true
  property :product_id,            Serial, :field => 'PRODUCTID', :key => true
  property :regdate,               DateTime, :field => 'REGDATE'
  property :nccregdate,            DateTime, :field => 'NCCREGDATE'
  property :nccregerror,           Integer, :field => 'NCCREGERROR'

  #has 1, :product, :child_key => [:PRODUCTID]
  #has 1, :product
  belongs_to :product
  belongs_to :client, :child_key => [:client_id]

end

class Client
  include DataMapper::Resource
  storage_names[:default] = 'Clients'

  property :id,                    String, :field => 'GUID',:key => true
  property :hostname,              String, :field => 'HOSTNAME'
  property :target,                String, :field => 'TARGET'
  property :description,           String, :field => 'DESCRIPTION'
  property :lastcontact,           DateTime, :field => 'LASTCONTACT'

  has n, :registration, :child_key => [:GUID]
end

class Subscription
  include DataMapper::Resource
  storage_names[:default] = 'Subscriptions'

  property :id,                    String, :field => 'SUBID',:key => true
  property :regcode,               String, :field => 'REGCODE'
  property :name,                  String, :field => 'SUBNAME'
  property :type,                  String, :field => 'SUBTYPE'
  property :status,                String, :field => 'SUBSTATUS'
  property :start_date,            DateTime, :field => 'SUBSTARTDATE'
  property :end_date,              DateTime, :field => 'SUBENDDATE'
  property :duration,              Integer, :field => 'SUBENDDATE'
  property :server_class,          String, :field => 'SERVERCLASS'
  property :product_class,         String, :field => 'PRODUCT_CLASS'
  property :node_count,            Integer, :field => 'NODECOUNT'
  property :consumed,              Integer, :field => 'CONSUMED'
end


class Target
  include DataMapper::Resource
  storage_names[:default] = 'Targets'

  property :id,                    String, :field => 'OS',:serial => true
  property :target,                String, :field => 'TARGET'
  property :src,                   String, :field => 'SRC'
end

class MachineData

  include DataMapper::Resource
  storage_names[:default] = 'MachineData'

  property :id,                    String, :field => 'GUID',:serial => true
  
  property :keyname,               String, :field => 'KEYNAME'
  property :value,                 Text, :field => 'VALUE'
end

#mime_type :json, "application/json"
#mime_type :xml, "text/xml"
#layout 'default.erb'
# new
get '/' do
  #erb :new, :layout => 'default.erb'
end

get '/catalogs.xml' do
  c = Catalog.all
  c = c.all(:mirrorable => 'Y') if params[:mirrorable] == 'Y'
  c = c.all(:domirror => 'Y') if params[:domirror] == 'Y'
  c = c.all(:name.like => "%#{params[:match]}%" ) if not params[:match].nil?
  xml = c.to_xml
  content_type 'text/xml', :charset => 'utf-8'
  xml
end

get '/catalogs/:id.xml' do
  c = Catalog.get(params[:id])
  not_found if c.nil?
  xml = c.to_xml
  content_type 'text/xml', :charset => 'utf-8'
  xml
end

get '/products.xml' do
  p = Product.all
  p = p.all(:name.like => "%#{params[:match]}%" ) if not params[:match].nil?
  xml = p.to_xml(:exclude => [:needinfo, :paramlist])
  content_type 'text/xml', :charset => 'utf-8'
  xml
end

get '/products/:id.xml' do
  p = Product.get(params[:id])
  not_found if p.nil?
  xml = p.to_xml(:exclude => [:needinfo, :paramlist])
  content_type 'text/xml', :charset => 'utf-8'
  xml
end

get '/products/:id/paramlist.xml' do
  p = Product.get(params[:id])
  not_found if p.nil?
  xml = p.paramlist
  content_type 'text/xml', :charset => 'utf-8'
  xml
end

get '/products/:id/needinfo.xml' do
  p = Product.get(params[:id])
  not_found if p.nil?
  xml = p.needinfo
  content_type 'text/xml', :charset => 'utf-8'
  xml
end

get '/clients.xml' do
  c = Client.all
  c = c.all(:hostname.like => "%#{params[:match]}%" ) if not params[:match].nil?
  not_found if c.nil?
  xml = c.to_xml
  content_type 'text/xml', :charset => 'utf-8'
  xml
end

get '/clients/:id.xml' do
  content_type 'text/xml', :charset => 'utf-8'
  c = Client.get(params[:id])
  c.to_xml if not c.nil?
end

get '/clients/:id/registrations.xml' do

  #proc = Proc.new do |options|
  #  options[:builder].tag!('id', options[:object].name.reverse)
  #end
 #object.to_xml :object => object, :procs => [ proc ]
  xml = Registration.all(:client_id => params[:id]).to_xml
  content_type 'text/xml', :charset => 'utf-8'
  xml
end

get '/clients/:id/products.xml' do
  content_type 'text/xml', :charset => 'utf-8'
  Product.all('registration.client.id' => params[:id]).to_xml
end

get '/registrations.xml' do
  content_type 'text/xml', :charset => 'utf-8'
  Registration.all.to_xml
end

get '/registrations/:id.xml' do
  content_type 'text/xml', :charset => 'utf-8'
  guid,pid = params[:id].split(';')
  c = Registration.get(guid, pid)
  c.to_xml(:exclude => :product_id, :include => :product)
end

get '/registrations/:id/product.xml' do
  content_type 'text/xml', :charset => 'utf-8'
  guid,pid = params[:id].split(';')
  # FIXME I dont know how to do a join using the composite keys
  r = Registration.get(guid, pid)
  if not r.nil?
    Product.get(pid).to_xml
  end
end

get '/subscriptions.xml' do
  content_type 'text/xml', :charset => 'utf-8'
  Subscription.all.to_xml
end

get '/subscriptions/:id.xml' do
  content_type 'text/xml', :charset => 'utf-8'
  s = Subscription.get(params[:id]).to_xml
end

get '/test.xml' do
  xml = '<true/>' if params[:foo]
  content_type 'text/xml', :charset => 'utf-8'
  xml
end
