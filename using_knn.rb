require 'rubygems'
require 'csv'
require_relative 'knn/lib/knn.rb'

def get_attribute_names data_table
  attr_row=data_table[0]
  attr_row.delete_at 0
  attr_row
end
def get_table_data data_table
  table_data= [[]]
  for i in (1...data_table.length)
    data_matrix_row= data_table[i]
    data_matrix_row.delete_at 0
    table_data.push data_matrix_row
  end
  table_data.delete_at 0
  table_data
end
def convert_to_int table
  new_table=[[]]
  for i in (0...table.length)
    changed_line= []
    for j in (0...table[i].length)
      #puts "#{i} and #{j} equals #{table[i][j].to_i}"
      changed_line.push table[i][j].to_i
    end
    new_table.push changed_line
  end
  new_table
end
data_matrix= CSV.read("trainJaffe.csv",:row_sep => "\r\n")
training_data= get_table_data data_matrix
training_data_int= convert_to_int training_data
training_data_int.delete_at 0
=begin
training_data_int.collect.each do |row|
  puts row.to_s
end
=end
training_labels_matrix= CSV.read("trainJaffeLabels.csv", :row_sep => "\r\n")
training_labels_data= get_table_data training_labels_matrix
training_labels_data_int= convert_to_int training_labels_data
training_labels_data_int.delete_at 0

knn = KNN.new(training_data_int, :distance_measure => :jaccard_distance)
k=3

test_matrix= CSV.read("testJaffe.csv",:row_sep => "\r\n")
test_data= convert_to_int( get_table_data test_matrix)
test_data.delete_at 0
output_labels=[]
test_data.each do |test_instance|
  result= knn.nearest_neighbours(test_instance, k)  # ([data], k's)
  countclass1=0
  countclassmin1=0
  for i in (0...result.length)
    if training_labels_data_int[result[i][0]][0]==1
      countclass1+=1
    else
      countclassmin1+=1
    end
  end
  #puts "+1 are #{countclass1} and -1 are #{countclassmin1}"
  output_labels << (countclass1> countclassmin1 ? 1: -1)
end
CSV.open("knnOutputLabels.csv", "wb") do |csv|
  csv << ["Id","label"]
  for i in (0...output_labels.length)
    csv << ["#{i+1}", "#{output_labels[i]}"]
  end
  # ...
end