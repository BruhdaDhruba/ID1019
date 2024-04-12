defmodule Test do
    def sample do
        'the quick brown fox jumps over the lazy dog
        this is a sample text that we will use when we build
        up a table we will only handle lower case letters and
        no punctuation symbols the frequency will of course not
        represent english but it is probably not that far off'
      end
      
      def text() do
        'this is something that we should encode'
      end
      
      def test1 do
        sample = sample()
        freq = Huffman.freq(sample)
        tree = Huffman.huffman_tree(freq)
        etable = Huffman.encode_table(tree)
        text = text()
        encoded = Huffman.encode(text, etable)
        dtable = Huffman.decode_table(etable)
        Huffman.decode(encoded, dtable)
      end

      def test2 do
        {:ok, text, n, b} = read("kallocain.txt")
        IO.puts("chars #{n} \nbytes #{b}")
        freq = Huffman.freq(text)
        tree = Huffman.huffman_tree(freq)
        etable = Huffman.encode_table(tree)
        encoded = Huffman.encode(text, etable)
        IO.puts("compressed: #{div(length(encoded), 8)}\n")
        dtable = Huffman.decode_table(etable)
        decoded = Huffman.naive(encoded, dtable)
        Enum.take(decoded, 10)
      end

      def test3 do
        {:ok, text, n, b} = read("kallocain.txt")
        IO.puts("chars #{n} \nbytes #{b}")
        freq = Huffman.freq(text)
        IO.puts("alphabet #{length(freq)}")
        tree = Huffman.huffman_tree(freq) 
        etable = Huffman.encode_table(tree)
        encoded = Huffman.encode(text, etable)
        IO.puts("compressed: #{div(length(encoded), 8)}\n")
        decoded = Huffman.decode(encoded, tree)
        IO.puts("#{[Enum.take(decoded, 10)]}\n")
      end

      def read(file) do
        str = File.read!(file)
        chars = String.to_charlist(str)
        {:ok, chars, length(chars), Kernel.byte_size(str)}
      end


      
      
end