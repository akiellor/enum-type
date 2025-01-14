require 'enum_type'

RSpec.describe EnumType do
  it 'is a module' do
    expect(EnumType).to be_instance_of Module
  end

  describe '.create' do
    context 'with no attributes' do
      let(:enum) do
        EnumType.create do
          RED(:red)
          GREEN(:green)
          BLUE(:blue)
        end
      end

      it 'defines all the enum types with the right value' do
        expect(enum.RED.value).to eq :red
        expect(enum.GREEN.value).to eq :green
        expect(enum.BLUE.value).to eq :blue
      end

      it 'defines all the enum types with the right name' do
        expect(enum.RED.name).to eq 'RED'
        expect(enum.GREEN.name).to eq 'GREEN'
        expect(enum.BLUE.name).to eq 'BLUE'
      end

      it 'defines all the enum types with simple equality rules' do
        expect(enum.RED).to eq enum.RED
        expect(enum.GREEN).to eq enum.GREEN
        expect(enum.BLUE).to eq enum.BLUE
      end

      it 'defines an enum type accessor on the enum' do
        expect(enum.RED.enum_type).to eq enum
        expect(enum.GREEN.enum_type).to eq enum
        expect(enum.BLUE.enum_type).to eq enum
      end

      it 'raises error on invalid enum name' do
        expect { enum.VIOLET }.to raise_error EnumType::UndefinedEnumError
      end

      it 'raises a NoMethodError if given arguments to a method' do
        expect { enum.RED('foo') }.to raise_error ArgumentError
      end

      it 'allows iterating over values' do
        expect(enum.entries).to eq [enum.RED, enum.GREEN, enum.BLUE]
        expect(enum.map(&:value)).to eq %i[red green blue]
      end

      it 'allows looking up by name' do
        expect(enum[:RED]).to equal enum.RED
      end

      it 'allows looking up by string name' do
        expect(enum['RED']).to equal enum.RED
      end

      it 'allows looking up by value' do
        expect(enum[:red]).to equal enum.RED
      end

      it 'returns nil if lookup by nil' do
        expect(enum[nil]).to be_nil
      end

      it 'allows getting the list of values' do
        expect(enum.values).to eq %i[red green blue]
      end

      it 'allows getting the list of names as symbols' do
        expect(enum.names).to eq %i[RED GREEN BLUE]
      end

      it 'defines to_s as name on the enums' do
        expect(enum.RED.to_s).to eq 'RED'
        expect(enum.GREEN.to_s).to eq 'GREEN'
        expect(enum.BLUE.to_s).to eq 'BLUE'
      end

      it 'defines inspect as a reasonable string on the enums' do
        expect(enum.RED.inspect).to eq '#<Enum:RED :red>'
        expect(enum.GREEN.inspect).to eq '#<Enum:GREEN :green>'
        expect(enum.BLUE.inspect).to eq '#<Enum:BLUE :blue>'
      end

      it 'defines inspect as a reasonable string on the enum itself' do
        expect(enum.inspect).to eq '#<EnumType enums=[RED, GREEN, BLUE]>'
      end
    end

    context 'with array attributes' do
      let(:enum) do
        EnumType.create(:hex, :rgb) do
          RED(:red, '#f00', [255, 0, 0])
          GREEN(:green, '#0f0', [0, 255, 0])
          BLUE(:blue, '#00f', [0, 0, 255])
        end
      end

      it 'defines all the enum types with the right value' do
        expect(enum.RED.value).to eq :red
        expect(enum.GREEN.value).to eq :green
        expect(enum.BLUE.value).to eq :blue
      end

      it 'defines an enum type accessor on the enum' do
        expect(enum.RED.enum_type).to eq enum
        expect(enum.GREEN.enum_type).to eq enum
        expect(enum.BLUE.enum_type).to eq enum
      end

      it 'defines all the enum types with the right name' do
        expect(enum.RED.name).to eq 'RED'
        expect(enum.GREEN.name).to eq 'GREEN'
        expect(enum.BLUE.name).to eq 'BLUE'
      end

      it 'defines other attributes correctly' do
        expect(enum.RED.hex).to eq '#f00'
        expect(enum.GREEN.hex).to eq '#0f0'
        expect(enum.BLUE.hex).to eq '#00f'
        expect(enum.RED.rgb).to eq [255, 0, 0]
        expect(enum.GREEN.rgb).to eq [0, 255, 0]
        expect(enum.BLUE.rgb).to eq [0, 0, 255]
      end

      it 'raises a NoMethodError if given arguments to a method' do
        expect { enum.RED('foo') }.to raise_error ArgumentError
      end

      it 'allows iterating over values' do
        expect(enum.entries).to eq [enum.RED, enum.GREEN, enum.BLUE]
        expect(enum.map(&:value)).to eq %i[red green blue]
        expect(enum.map(&:hex)).to eq %w[#f00 #0f0 #00f]
        expect(enum.map(&:rgb)).to eq [[255, 0, 0], [0, 255, 0], [0, 0, 255]]
      end

      it 'allows getting the list of values' do
        expect(enum.values).to eq %i[red green blue]
      end

      it 'allows getting the list of names as symbols' do
        expect(enum.names).to eq %i[RED GREEN BLUE]
      end

      it 'defines to_s as name on the enums' do
        expect(enum.RED.to_s).to eq 'RED'
        expect(enum.GREEN.to_s).to eq 'GREEN'
        expect(enum.BLUE.to_s).to eq 'BLUE'
      end

      it 'defines inspect as a reasonable string on the enums' do
        expect(enum.RED.inspect).to eq '#<Enum:RED :red>'
        expect(enum.GREEN.inspect).to eq '#<Enum:GREEN :green>'
        expect(enum.BLUE.inspect).to eq '#<Enum:BLUE :blue>'
      end

      it 'defines inspect as a reasonable string on the enum itself' do
        expect(enum.inspect).to eq '#<EnumType enums=[RED, GREEN, BLUE]>'
      end
    end

    context 'with hash attributes' do
      let(:enum) do
        EnumType.create(value: String, hex: String, rgb: Array) do
          RED('red', '#f00', [255, 0, 0])
          GREEN('green', '#0f0', [0, 255, 0])
          BLUE('blue', '#00f', [0, 0, 255])
        end
      end

      it 'defines all the enum types with the right value' do
        expect(enum.RED.value).to eq 'red'
        expect(enum.GREEN.value).to eq 'green'
        expect(enum.BLUE.value).to eq 'blue'
      end

      it 'defines all the enum types with the right name' do
        expect(enum.RED.name).to eq 'RED'
        expect(enum.GREEN.name).to eq 'GREEN'
        expect(enum.BLUE.name).to eq 'BLUE'
      end

      it 'defines other attributes correctly' do
        expect(enum.RED.hex).to eq '#f00'
        expect(enum.GREEN.hex).to eq '#0f0'
        expect(enum.BLUE.hex).to eq '#00f'
        expect(enum.RED.rgb).to eq [255, 0, 0]
        expect(enum.GREEN.rgb).to eq [0, 255, 0]
        expect(enum.BLUE.rgb).to eq [0, 0, 255]
      end

      it 'raises a NoMethodError if given arguments to a method' do
        expect { enum.RED('foo') }.to raise_error ArgumentError
      end

      it 'allows iterating over values' do
        expect(enum.entries).to eq [enum.RED, enum.GREEN, enum.BLUE]
        expect(enum.map(&:value)).to eq %w[red green blue]
        expect(enum.map(&:hex)).to eq %w[#f00 #0f0 #00f]
        expect(enum.map(&:rgb)).to eq [[255, 0, 0], [0, 255, 0], [0, 0, 255]]
      end

      it 'allows getting the list of values' do
        expect(enum.values).to eq %w[red green blue]
      end

      it 'allows getting the list of names as symbols' do
        expect(enum.names).to eq %i[RED GREEN BLUE]
      end

      it 'defines to_s as name on the enums' do
        expect(enum.RED.to_s).to eq 'RED'
        expect(enum.GREEN.to_s).to eq 'GREEN'
        expect(enum.BLUE.to_s).to eq 'BLUE'
      end

      it 'defines inspect as a reasonable string on the enums' do
        expect(enum.RED.inspect).to eq '#<Enum:RED "red">'
        expect(enum.GREEN.inspect).to eq '#<Enum:GREEN "green">'
        expect(enum.BLUE.inspect).to eq '#<Enum:BLUE "blue">'
      end

      it 'defines inspect as a reasonable string on the enum itself' do
        expect(enum.inspect).to eq '#<EnumType enums=[RED, GREEN, BLUE]>'
      end
    end

    context 'with hash attributes and dry types' do
      let(:value_type) { Dry.Types::String }
      let(:hex_type) { Dry.Types::String.optional }
      let(:rgb_type) do
        Dry.Types.Array(
          Dry.Types::Strict::Integer.constrained(lteq: 255, gteq: 0)
        ).constrained(size: 3)
      end
      let(:enum) do
        EnumType.create(value: value_type, hex: hex_type, rgb: rgb_type) do
          RED('red', '#f00', [255, 0, 0])
          GREEN('green', '#0f0', [0, 255, 0])
          BLUE('blue', '#00f', [0, 0, 255])
        end
      end

      it 'defines the enum types with the right value' do
        expect(enum.RED).to have_attributes(
          value: 'red',
          name: 'RED',
          hex: '#f00',
          rgb: [255, 0, 0]
        )
        expect(enum.GREEN).to have_attributes(
          value: 'green',
          name: 'GREEN',
          hex: '#0f0',
          rgb: [0, 255, 0]
        )
        expect(enum.BLUE).to have_attributes(
          value: 'blue',
          name: 'BLUE',
          hex: '#00f',
          rgb: [0, 0, 255]
        )
      end

      context 'when an enum doesnt match the types' do
        let(:enum) do
          EnumType.create(value: value_type, hex: hex_type, rgb: rgb_type) do
            RED(nil, '#f00', [255, 0, 0])
            GREEN('green', '#0f0', [0, 255, 0])
            BLUE('blue', '#00f', [0, 0, 255])
          end
        end

        it 'raises a TypeError' do
          expect { enum }.to raise_error EnumType::TypeError
        end
      end

      context 'when an enum doesnt match the type constraints' do
        let(:enum) do
          EnumType.create(value: value_type, hex: hex_type, rgb: rgb_type) do
            RED('red', '#f00', [256, 0, 0])
            GREEN('green', '#0f0', [-1, 255, 0])
            BLUE('blue', '#00f', [0, 255])
          end
        end

        it 'raises a TypeError' do
          expect { enum }.to raise_error EnumType::TypeError
        end
      end
    end

    context 'with array attributes and :value as an attribute' do
      let(:enum) do
        EnumType.create(:value, :rgb) do
          RED(:red, '#f00')
          GREEN(:green, '#0f0')
          BLUE(:blue, '#00f')
        end
      end

      it 'raises an error' do
        expect { enum }.to raise_error EnumType::InvalidDefinitionError
      end
    end

    context 'with array attributes and "name" as an attribute' do
      let(:enum) do
        EnumType.create('name', 'rgb') do
          RED(:red, '#f00')
          GREEN(:green, '#0f0')
          BLUE(:blue, '#00f')
        end
      end

      it 'raises an error' do
        expect { enum }.to raise_error EnumType::InvalidDefinitionError
      end
    end

    context 'with array attributes and "value" as an attribute' do
      let(:enum) do
        EnumType.create('value', 'rgb') do
          RED(:red, '#f00')
          GREEN(:green, '#0f0')
          BLUE(:blue, '#00f')
        end
      end

      it 'raises an error' do
        expect { enum }.to raise_error EnumType::InvalidDefinitionError
      end
    end

    context 'with array attributes and :name as an attribute' do
      let(:enum) do
        EnumType.create(:name, :rgb) do
          RED(:red, '#f00')
          GREEN(:green, '#0f0')
          BLUE(:blue, '#00f')
        end
      end

      it 'raises an error' do
        expect { enum }.to raise_error EnumType::InvalidDefinitionError
      end
    end

    context 'with hash attributes and an invalid definition' do
      let(:enum) do
        EnumType.create(value: Symbol, hex: String, rgb: Array) do
          RED(:red, '#f00', [255, 0, 0])
          GREEN(:green, 27, [0, 255, 0])
        end
      end

      it 'raises a type error' do
        expect { enum }.to raise_error EnumType::TypeError
      end
    end

    context 'an enum with a lower case type' do
      let(:enum) do
        EnumType.create do
          red(:red)
        end
      end

      it 'raises an error' do
        expect { enum }.to raise_error EnumType::InvalidDefinitionError
      end
    end

    context 'an enum with an empty type' do
      let(:enum) do
        EnumType.create do
          RED()
        end
      end

      it 'raises an error' do
        expect { enum }.to raise_error EnumType::InvalidDefinitionError
      end
    end

    context 'with duplicated definitions' do
      let(:enum) do
        EnumType.create do
          RED(:red)
          GREEN(:green)
          RED(:blue)
        end
      end

      it 'raises an error' do
        expect { enum }.to raise_error EnumType::DuplicateDefinitionError
      end
    end

    context 'with duplicated values' do
      let(:enum) do
        EnumType.create do
          RED(:red)
          GREEN(:green)
          BLUE(:red)
        end
      end

      it 'raises an error' do
        expect { enum }.to raise_error EnumType::DuplicateDefinitionError
      end
    end

    context 'with an empty block' do
      let(:enum) { EnumType.create {} }

      it 'raises an InvalidDefinitionError' do
        expect { enum }.to raise_error EnumType::InvalidDefinitionError
      end
    end

    context 'with no block' do
      let(:enum) { EnumType.create }

      it 'raises an InvalidDefinitionError' do
        expect { enum }.to raise_error EnumType::InvalidDefinitionError
      end
    end

    context 'with an enum definition with a block' do
      let(:enum) do
        EnumType.create do
          RED(:red) { 'foo' }
        end
      end

      it 'raises an InvalidDefinitionError' do
        expect { enum }.to raise_error EnumType::InvalidDefinitionError
      end
    end
  end
end
