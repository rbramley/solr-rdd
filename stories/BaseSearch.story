@Grab(group='org.apache.solr', module='solr-solrj', version='1.4.1')
@Grab(group='org.slf4j', module='slf4j-nop', version='1.6.2')

import org.apache.solr.client.solrj.*
import org.apache.solr.client.solrj.impl.CommonsHttpSolrServer
import org.apache.solr.client.solrj.response.*
import org.apache.solr.common.*

SolrServer server
 
before "configure search client", {
 url = 'http://localhost:8983/solr'
 server = new CommonsHttpSolrServer(url)
}

before "set up constrained data", {
 given "our sample product data set", {
    SolrInputDocument doc1 = new SolrInputDocument()
    doc1.addField("id", "PRD-123", 1.0f)
    doc1.addField("name", "Best exercise bike", 1.5f)
    doc1.addField("price", 100)
    
    SolrInputDocument doc2 = new SolrInputDocument()
    doc2.addField("id", "PRD-234", 1.0f)
    doc2.addField("name", "Old exercise bike", 1.0f )
    doc2.addField("price", 20)
    
    Collection<SolrInputDocument> docs = new ArrayList<SolrInputDocument>()
    docs.add(doc1)
    docs.add(doc2)

    server.add(docs)
    server.commit()
 }
}

scenario "Exercise bikes",{
 SolrQuery query = new SolrQuery()
 def rdocs

 when "I search for 'exercise bike'", {
    query.setQuery("name:\"exercise bike\"")
    query.addField('score')
 }
 and "I sort by price descending", {
    query.addSortField("price", SolrQuery.ORDER.desc)
 }
 then "I should get two results with ids [PRD-123,PRD-234]", {
    QueryResponse rsp = server.query( query )
    rdocs = rsp.getResults()

    rdocs.size().shouldBe(2)

    rdocs[0].id.shouldBe('PRD-123')
    rdocs[1].id.shouldBe('PRD-234')
 }
 and "PRD-123 has a higher score than PRD-234", {
   rdocs[0].score.shouldBeGreaterThan(rdocs[1].score)
 }
}
