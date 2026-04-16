# frozen_string_literal: true

require 'spec_helper'
require 'vault_coh'
require 'reinforce'

# Cross-stack integration test: verifies that cohlib-rb produces identical
# build order output to the existing vault_coh + reinforce stack for a known
# replay. This exercises the full replacement path: parser → build order
# extraction → per-action fields.
#
# Action type mapping between stacks:
#   reinforce (raw command name) → cohlib (semantic name)
#   "UseAbility"                 → "construct_building"
#   "BuildSquad"                 → "train_unit"
#   "BuildGlobalUpgrade"         → "research_upgrade"
#   "SelectBattlegroup"          → "select_battlegroup"
#   "SelectBattlegroupAbility"   → "select_battlegroup_ability"
#   "UseBattlegroupAbility"      → "use_battlegroup_ability"
#   "AITakeover"                 → "ai_takeover"

REINFORCE_TO_COHLIB_ACTION = {
  'UseAbility' => 'construct_building',
  'BuildSquad' => 'train_unit',
  'BuildGlobalUpgrade' => 'research_upgrade',
  'SelectBattlegroup' => 'select_battlegroup',
  'SelectBattlegroupAbility' => 'select_battlegroup_ability',
  'UseBattlegroupAbility' => 'use_battlegroup_ability',
  'AITakeover' => 'ai_takeover'
}.freeze

RSpec.describe 'cross-stack build order parity' do
  let(:replay_path) { File.expand_path('../../cohlib/replays/USvDAK_v10612.rec', __dir__) }
  let(:replay_bytes) { File.binread(replay_path).bytes }

  before { skip 'replay fixture not found' unless File.exist?(replay_path) }

  # vault_coh + reinforce side
  let(:vault_replay) { VaultCoh::Replay.from_bytes(replay_bytes) }
  let(:build_number) { vault_replay.version }

  def reinforce_actions_for(player_index)
    player = vault_replay.players[player_index]
    Reinforce.build_for(player, build_number).map do |cmd|
      {
        tick: cmd.tick,
        pbgid: cmd.pbgid,
        action_type: REINFORCE_TO_COHLIB_ACTION.fetch(cmd.action_type),
        suspect: cmd.suspect?
      }
    end
  end

  # cohlib-rb side
  let(:store) { CohLib::VersionedStore.bundled }
  let(:cohlib_replay) { CohLib::Replay.from_bytes(replay_bytes) }

  def cohlib_actions_for(player_index)
    store.extract_build_order(cohlib_replay, player_index).actions.map do |a|
      # AITakeover has no meaningful pbgid; cohlib uses 0, reinforce uses nil.
      # Normalize to nil for comparison.
      pbgid = a.action_type == 'ai_takeover' ? nil : a.pbgid
      {
        tick: a.tick,
        pbgid: pbgid,
        action_type: a.action_type,
        suspect: a.suspect
      }
    end
  end

  shared_examples 'matching build orders' do |player_index, player_name|
    context "player #{player_index} (#{player_name})" do
      let(:reinforce) { reinforce_actions_for(player_index) }
      let(:cohlib) { cohlib_actions_for(player_index) }

      it 'produces the same number of actions' do
        expect(cohlib.length).to eq(reinforce.length),
          "cohlib: #{cohlib.length} actions, reinforce: #{reinforce.length} actions"
      end

      it 'matches tick-by-tick' do
        reinforce.zip(cohlib).each_with_index do |(r, c), i|
          expect(c).to eq(r),
            "action[#{i}] mismatch:\n  cohlib:    #{c}\n  reinforce: #{r}"
        end
      end
    end
  end

  include_examples 'matching build orders', 0, 'madhax (Americans)'
  include_examples 'matching build orders', 1, 'Quixalotl (AfrikaKorps)'
end
