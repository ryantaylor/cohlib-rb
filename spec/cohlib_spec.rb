# frozen_string_literal: true

require 'spec_helper'

REPLAY_PATH = File.expand_path('../../cohlib/replays/USvDAK_v10612.rec', __dir__)

RSpec.describe CohLib do
  it 'has a version number' do
    expect(CohLib::VERSION).not_to be_nil
  end
end

RSpec.describe CohLib::VersionedStore do
  subject(:store) { described_class.bundled }

  it 'loads the bundled store' do
    expect(store).to be_a(described_class)
  end
end

RSpec.describe CohLib::Replay do
  subject(:replay) { described_class.from_bytes(File.binread(REPLAY_PATH).bytes) }

  before { skip 'replay fixture not found' unless File.exist?(REPLAY_PATH) }

  it 'parses the version' do
    expect(replay.version).to eq(10612)
  end

  it 'returns two players' do
    expect(replay.players.length).to eq(2)
  end

  it 'returns a non-nil matchhistory_id' do
    expect(replay.matchhistory_id).not_to be_nil
  end

  it 'returns a positive length' do
    expect(replay.length).to be_positive
  end
end

RSpec.describe CohLib::Player do
  let(:store) { CohLib::VersionedStore.bundled }
  let(:replay) { CohLib::Replay.from_bytes(File.binread(REPLAY_PATH).bytes) }
  let(:players) { replay.players }

  before { skip 'replay fixture not found' unless File.exist?(REPLAY_PATH) }

  it 'exposes player names' do
    expect(players.map(&:name)).to all(be_a(String))
  end

  it 'marks human players correctly' do
    expect(players.map(&:human?)).to all(be(true))
  end

  it 'exposes factions' do
    factions = players.map(&:faction)
    expect(factions).to include('americans')
    expect(factions).to include('afrika_korps')
  end
end

RSpec.describe CohLib::BuildOrder do
  let(:store) { CohLib::VersionedStore.bundled }
  let(:replay) { CohLib::Replay.from_bytes(File.binread(REPLAY_PATH).bytes) }

  before { skip 'replay fixture not found' unless File.exist?(REPLAY_PATH) }

  it 'returns a BuildOrder for player 0' do
    bo = store.extract_build_order(replay, 0)
    expect(bo).to be_a(CohLib::BuildOrder)
  end

  it 'contains BuildAction objects' do
    bo = store.extract_build_order(replay, 0)
    expect(bo.actions).to all(be_a(CohLib::BuildAction))
  end

  it 'action to_h has expected keys' do
    bo = store.extract_build_order(replay, 0)
    h = bo.actions.first.to_h
    expect(h).to include(:tick, :action_type, :pbgid, :suspect)
  end

  it 'first action for player 0 is train_unit at tick 28' do
    bo = store.extract_build_order(replay, 0)
    first = bo.actions.first
    expect(first.tick).to eq(28)
    expect(first.action_type).to eq('train_unit')
    expect(first.pbgid).to eq(198_340)
  end
end
