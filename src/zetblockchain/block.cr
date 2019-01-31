require "openssl"

module Zetblockchain
  class Block

    include ProofOfWork

    # property current_hash : String
    # property index : Int32
    # property nonce : Int32
    # property previous_hash : String

    JSON.mapping(
      index: Int32,
      current_hash: String,
      nonce: Int32,
      previous_hash: String,
      transactions: Array(Transaction),
      timestamp: Time
    )

    def initialize(index = 0, transactions = [] of Transaction, previous_hash = "hash")
      @transactions = transactions
      @index = index
      @timestamp = Time.now
      @previous_hash = previous_hash
      @nonce = proof_of_work
      @current_hash = calc_hash_with_nonce(@nonce)
    end

    def self.first(data = "Genesis Block")
      Block.new(data: data, previous_hash: "0")
    end

    def self.next(previous_block, transactions = [] of Transaction)
      Block.new(
        transactions: transactions,
        index: previous_block.index + 1,
        previous_hash: previous_block.current_hash
      )
    end

    def recalculate_hash
      @nonce = proof_of_work
      @current_hash = calc_hash_with_nonce(@nonce)
    end

    private def hash_block
      hash = OpenSSL::Digest.new("SHA256")
      hash.update("#{@index}#{@timestamp}#{@data}#{@previous_hash}")
      hash.hexdigest
    end
  end
end
p BitupperCoin::Block.first
puts BitupperCoin::Block.new(data: "Same Data").current_hash
