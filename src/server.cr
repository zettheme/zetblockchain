require "kemal"
require "./zetblockchain"

# Generate a globally unique address for this node
node_identifier = UUID.random.to_s

# Create our Blockchain
blockchain = Blockchain.new

get "/chain" do
  { chain: blockchain.chain }.to_json
end

get "/mine" do
  blockchain.mine
  "Block with index=#{blockchain.chain.last.index} is mined."
end

get "/pending" do
  "Send pending transactions as json objects"
end

post "/transactions/new" do
  "We'll add a new transaction"
end

post "/nodes/register" do |env|
  nodes = env.params.json["nodes"].as(Array)

  raise "Empty array" if nodes.empty?

  nodes.each do |node|
    blockchain.register_node(node.to_s)
  end

  "New nodes have been added: #{blockchain.nodes}"
end

get "/nodes/resolve" do
  if blockchain.resolve
    "Successfully updated the chain"
  else
    "Current chain is up-to-date"
  end
end


Kemal.run
