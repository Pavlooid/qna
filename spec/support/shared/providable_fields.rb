shared_examples_for 'providable fields' do
  it 'returns all public fields' do
    all_fields.each do |attr|
      expect(object_response[attr]).to eq object.send(attr).as_json
    end
  end
end
