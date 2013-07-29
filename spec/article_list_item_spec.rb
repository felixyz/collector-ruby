require 'spec_helper'

describe Collector::ArticleListItem do
  let (:article_list_item_hash) {
    { "article_id" => "123",
      "description" => "A fine piece",
      "quantity" => "23",
    }
  }
  it "can be constructed from a hash" do
    aticle = Collector::ArticleListItem.new( article_list_item_hash )
    aticle.article_id.should eq "123"
    aticle.description.should eq "A fine piece"
    aticle.quantity.should eq "23"
  end

  it "can be constructed from an InvoiceRow instance" do
    invoice_row = Collector::InvoiceRow.new(sandbox_invoice_row_hash)
    article = Collector::ArticleListItem.new( invoice_row )
    article.article_id.should eq "12"
    article.description.should eq "A wonderful thing"
    article.quantity.should eq "2"
  end

  it "converts to hash and back without losing information" do
    obj = Collector::ArticleListItem.new( article_list_item_hash )
    hash = Collector::ArticleListItemRepresenter.new(obj).to_hash
    obj2 = Collector::ArticleListItem.new
    Collector::ArticleListItemRepresenter.new(obj2).from_hash(hash)
    obj2.should eq obj
  end

end