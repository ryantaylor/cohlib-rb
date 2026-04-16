# cohlib-rb

Ruby bindings for [cohlib](../cohlib/), a Rust library for parsing Company of Heroes 3 replay files and extracting build orders.

cohlib-rb exposes a native extension that wraps cohlib's core functionality: replay parsing, build order extraction, and version-aware game data access. All historical game data (32 versions) is compiled into the native extension binary, so no external setup or data files are needed.

## Requirements

- Ruby >= 3.1
- Rust toolchain (for building the native extension)
- `rb_sys` and `rake-compiler` gems

## Installation

Add to your Gemfile:

```ruby
gem 'cohlib'
```

Or install directly:

```sh
gem install cohlib
```

## Quick start

```ruby
require 'cohlib'

# Load the bundled game data store once and reuse it
store = CohLib::VersionedStore.bundled

# Parse a replay from raw bytes
replay = CohLib::Replay.from_bytes(File.binread('match.rec').bytes)

puts replay.version          # => 10612
puts replay.game_type        # => "automatch"
puts replay.players.count    # => 2

# Extract the build order for player 0
build_order = store.extract_build_order(replay, 0)
build_order.actions.each do |action|
  puts "#{action.tick / 8}s  #{action.action_type}  pbgid=#{action.pbgid}"
end
```

## API reference

### `CohLib::VersionedStore`

A version-aware store of CoH3 game data. Create one instance and reuse it across requests — loading the bundled data decompresses and deserializes 32 game versions.

#### `.bundled -> VersionedStore`

Load all historical game data compiled into the library.

```ruby
store = CohLib::VersionedStore.bundled
```

#### `#extract_build_order(replay, player_index) -> BuildOrder`

Extract the build order for one player from a parsed replay. Game data is resolved using the replay's build version with automatic fallback to the nearest known version.

```ruby
build_order = store.extract_build_order(replay, 0)   # player 0
build_order = store.extract_build_order(replay, 1)   # player 1
```

Raises `RuntimeError` if `player_index` is out of range.

---

### `CohLib::Replay`

A parsed CoH3 replay. All fields are read-only and populated at parse time.

#### `.from_bytes(bytes) -> Replay`

Parse a replay from a byte array.

```ruby
replay = CohLib::Replay.from_bytes(File.binread('match.rec').bytes)
```

Raises `RuntimeError` on parse failure.

#### Instance methods

| Method | Return type | Description |
|---|---|---|
| `version` | `Integer` | Build version encoded in the replay header (e.g. `10612`) |
| `timestamp` | `String` | Recording timestamp as stored in the file |
| `game_type` | `String` | `"skirmish"`, `"multiplayer"`, `"automatch"`, or `"custom"` |
| `matchhistory_id` | `Integer` or `nil` | Relic match ID; `nil` for skirmish games |
| `mod_uuid` | `String` | UUID of the active mod; all-zeros UUID for the base game |
| `map_filename` | `String` | Scenario filename |
| `map_localized_name_id` | `String` | Localization key for the map name |
| `map_localized_description_id` | `String` | Localization key for the map description |
| `length` | `Integer` | Total tick count; divide by 8 for duration in seconds |
| `players` | `Array<Player>` | All players in the match |

---

### `CohLib::Player`

A player in a parsed replay.

| Method | Return type | Description |
|---|---|---|
| `name` | `String` | Display name at time of recording |
| `human?` | `Boolean` | `true` if human, `false` if AI |
| `faction` | `String` | `"americans"`, `"british_africa"`, `"germans"`, or `"afrika_korps"` |
| `team` | `Integer` | Team index: `0` (first team) or `1` (second team) |
| `battlegroup` | `Integer` or `nil` | pbgid of the selected battlegroup; `nil` if none chosen |
| `battlegroup_selected_at` | `Integer` or `nil` | Tick at which the battlegroup was selected |
| `ai_takeover_at` | `Integer` or `nil` | Tick at which AI took over; `nil` if the player never dropped |
| `steam_id` | `Integer` or `nil` | 64-bit Steam ID; `nil` for AI players |
| `profile_id` | `Integer` or `nil` | Relic profile ID; `nil` for AI players |
| `messages` | `Array<Message>` | Chat messages sent by this player, in chronological order |

---

### `CohLib::Message`

A chat message sent by a player during a match.

| Method | Return type | Description |
|---|---|---|
| `tick` | `Integer` | Tick at which the message was sent; divide by 8 for seconds |
| `message` | `String` | Message text |
| `to_h` | `Hash` | `{ tick:, message: }` |

---

### `CohLib::BuildOrder`

The complete build order for a single player, obtained from `VersionedStore#extract_build_order`.

| Method | Return type | Description |
|---|---|---|
| `actions` | `Array<BuildAction>` | Chronologically ordered list of build actions |

---

### `CohLib::BuildAction`

A single action in a player's build order.

| Method | Return type | Description |
|---|---|---|
| `tick` | `Integer` | Game tick of the action; divide by 8 for seconds |
| `index` | `Integer` | Command index within the tick, used for ordering tied actions |
| `action_type` | `String` | Classification of the action (see below) |
| `pbgid` | `Integer` | pbgid of the entity, ability, or upgrade involved |
| `suspect` | `Boolean` | `true` if this building may have been cancelled before first use |
| `cancelled` | `Boolean` | `true` if the action was explicitly cancelled |
| `to_h` | `Hash` | `{ tick:, action_type:, pbgid:, suspect: }` |

#### Action types

| `action_type` | Description |
|---|---|
| `"construct_building"` | A building was placed using an autobuild ability |
| `"train_unit"` | A squad was trained |
| `"research_upgrade"` | An upgrade was researched |
| `"select_battlegroup"` | A battlegroup was selected |
| `"select_battlegroup_ability"` | A battlegroup ability slot was selected |
| `"use_battlegroup_ability"` | A battlegroup ability was used |
| `"ai_takeover"` | The player dropped and AI took over; this is always the last action |

#### Suspect buildings

When a building is cancelled, cohlib marks subsequent placements of the same building type as suspects until a unit or upgrade is actually produced from one of them. A `suspect: true` action should be validated against subsequent production before being displayed to users. Cancelled actions (`cancelled: true`) are never included in the returned actions list.

## Usage patterns

### Cache the store

`VersionedStore.bundled` loads and decompresses the bundled game data on every call. Create one instance per process (or per Rails boot) and reuse it:

```ruby
# config/initializers/cohlib.rb
COHLIB_STORE = CohLib::VersionedStore.bundled
```

### Process a replay

```ruby
def parse(path)
  replay = CohLib::Replay.from_bytes(File.binread(path).bytes)
  {
    version: replay.version,
    game_type: replay.game_type,
    map: replay.map_filename,
    duration_seconds: replay.length / 8,
    players: replay.players.map { |p| player_hash(p) }
  }
end

def player_hash(player)
  {
    name: player.name,
    faction: player.faction,
    team: player.team,
    human: player.human?,
    steam_id: player.steam_id
  }
end
```

### Extract and render a build order

```ruby
def build_order_for(replay, player_index, store: COHLIB_STORE)
  store.extract_build_order(replay, player_index).actions.map do |action|
    {
      time: "#{action.tick / 8}s",
      type: action.action_type,
      pbgid: action.pbgid,
      suspect: action.suspect
    }
  end
end
```

### Check for AI games

```ruby
replay.players.all?(&:human?)      # true for all-human game
replay.players.any? { |p| !p.human? }  # true if any AI
```

## Building from source

```sh
git clone https://github.com/ryantaylor/cohlib-rb
cd cohlib-rb
bundle install
bundle exec rake compile   # builds the native Rust extension
bundle exec rspec          # runs the test suite
```

The native extension links against cohlib, which embeds all historical game data at compile time via `build.rs`. The first build is slow (compiling the full dependency tree including libwebp); subsequent builds are incremental.

## Running tests

```sh
bundle exec rspec                          # full suite
bundle exec rspec spec/cohlib_spec.rb      # unit + smoke tests
bundle exec rspec spec/cross_stack_spec.rb # parity vs vault_coh + reinforce
```

The cross-stack spec requires `vault_coh` and `reinforce` to be available as local path gems. It parses a known replay with both the old and new stacks and verifies that build order output matches tick-by-tick.
