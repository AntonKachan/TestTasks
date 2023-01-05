object @invoice => false
node(:total_price) { @invoice[:total_price].format }
