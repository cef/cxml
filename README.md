# cXML

Ruby implementation of cXML protocol. 

## Documentation

Procotol specifications could be found here [http://xml.cxml.org/current/cXMLUsersGuide.pdf](http://xml.cxml.org/current/cXMLUsersGuide.pdf)

To add a DTD and version, add a cxml.rb in config/initializers

```
CXML.configure do |c|
  CXML.cxml_version = '1.2.047'
end
```

Replace the cxml_version with your CXML standard version of choice.

## Running Tests

Install dependencies:

```
bundle install
```

Run suite:

```
rake test
```