require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-serializer'
#require 'syntaxi'

### SETUP

DataMapper.setup(:default, "mysql://root@localhost/smt")

class Catalog
  include DataMapper::Resource
  storage_names[:default] = 'Catalogs'

  property :id,                    String, :field => 'CATALOGID',:serial => true
  property :name,                  String, :field => 'NAME'
  property :description,           String, :field => 'DESCRIPTION'
  property :target,                String, :field => 'TARGET'
  property :description,           String, :field => 'DESCRIPTION'
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

  property :id,                    Serial, :field => 'PRODUCTDATAID',:serial => true
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
end

class Client
  include DataMapper::Resource
  storage_names[:default] = 'Clients'

  property :id,                    String, :field => 'GUID',:serial => true
  property :hostname,              String, :field => 'HOSTNAME'
  property :target,                String, :field => 'TARGET'
  property :description,           String, :field => 'DESCRIPTION'
  property :lastcontact,           DateTime, :field => 'LASTCONTACT'
end

class Subscription
  include DataMapper::Resource
  storage_names[:default] = 'Subscriptions'

  property :id,                    String, :field => 'SUBID',:serial => true
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

class Registration
  include DataMapper::Resource
  storage_names[:default] = 'Registration'
  
  property :id,                    String, :field => 'GUID',:serial => true
  property :productid,             Serial, :field => 'PRODUCTID'
  property :regdate,               DateTime, :field => 'REGDATE'
  property :nccregdate,            DateTime, :field => 'NCCREGDATE'
  property :nccregerror,           Integer, :field => 'NCCREGERROR'

  has 1, :product, :child_key => [:productid]
  
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

#layout 'default.erb'

# new
get '/' do
  #erb :new, :layout => 'default.erb'
end

get '/catalogs' do
  content_type 'text/xml', :charset => 'utf-8'
  Catalog.all.to_xml
end

get '/catalogs/:id' do
  content_type 'text/xml', :charset => 'utf-8'
  c = Catalog.get(params[:id])
  c.to_xml
end

get '/products' do
  content_type 'text/xml', :charset => 'utf-8'
  Product.all.to_xml
end

get '/products/:id' do
  content_type 'text/xml', :charset => 'utf-8'
  c = Product.get(params[:id])
  c.to_xml
end

get '/clients' do
  content_type 'text/xml', :charset => 'utf-8'
  Client.all.to_xml
end

get '/clients/:id' do
  content_type 'text/xml', :charset => 'utf-8'
  c = Client.get(params[:id])
  c.to_xml
end

get '/registrations' do
  content_type 'text/xml', :charset => 'utf-8'
  Registration.all.to_xml
end

get '/registration/:id' do
  content_type 'text/xml', :charset => 'utf-8'
  c = Registration.get(params[:id])
  c.to_xml
end

