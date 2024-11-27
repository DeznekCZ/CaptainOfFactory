
local slag_item = { type="item", name="stone", amount=1 }
local iron_temperature = 1500;
local copper_temperature = 1100;

data.raw.recipe["iron-plate"] = nil;
data.raw.recipe["copper-plate"] = nil;

data:extend{
    {
        type="recipe",
        name="molten-iron-simple",
        icon="__space-age__/graphics/icons/fluid/molten-iron.png",
        category="smelting",
        energy_required=5,
        ingredients={
            { type="item", name="iron-ore", amount=8 }
        },
        results={
            { type="fluid", name="molten-iron", amount=50, temperature=iron_temperature },
            slag_item
        },
        enabled=true
    },
    {
        type="recipe",
        name="molten-copper-simple",
        icon="__space-age__/graphics/icons/fluid/molten-copper.png",
        category="smelting",
        energy_required=5,
        ingredients={
            { type="item", name="copper-ore", amount=8 }
        },
        results={
            { type="fluid", name="molten-copper", amount=50, temperature=copper_temperature },
            slag_item
        },
        enabled=true
    }
}

local furnace = data.raw.furnace["stone-furnace"]
furnace.fluid_boxes = {
    {
        volume=50,
        production_type="output",
        pipe_connections={
            {
                connection_type="normal", 
                flow_direction="output",
                direction=defines.direction.east,
                position={x=0.5,y=0.5},
                connection_category="molten-channel"
            }
        },
    }
}

---comment
---@param parameters { planet:string, cooling_time:integer, cooled:boolean, source:{ fluid:string, amount:integer, temperature:integer }, result:{ item:string, amount:integer }}
---@return table
local function stone_form(parameters)
    local icons = {
        { icon="__base__/graphics/icons/stone.png" },
        { icon="__base__/graphics/icons/"..parameters.result.item..".png" },
    }
    local form_name = parameters.planet .. "-" .. parameters.result.item .. "-cast-form";
    local cast_recipe_name = parameters.planet .. "-" .. parameters.result.item .. "-cast-recipe";
    local cast_category_name = parameters.planet .. "-cast-category";

    local cooling_name = {"entity-name.form", {"item-name." .. parameters.result.item}, {"fluid-name."..parameters.source.fluid}};
    local cooling_description = {"entity-description.cooling", {"item-name." .. parameters.result.item}, {"fluid-name."..parameters.source.fluid}};

    local assembler = {
        name=form_name,
        localised_name=cooling_name,
        localised_decription=cooling_description,
        type="assembling-machine",
        icons=icons,
        ingredient_count=1, --resource and coolant
        fluid_boxes = {
            {
                volume=parameters.source.amount,
                production_type="input",
                pipe_connections={
                    {
                        connection_type="normal", 
                        flow_direction="input",
                        direction=defines.direction.west,
                        position={x=0,y=0},
                        connection_category="molten-channel"
                    }
                },
            }
        },
        fixed_recipe=cast_recipe_name,
        hidden = false,
        subgroup = "forms",
        placeable_by={
            item=form_name,
            count=1
        },
        minable={
            result=form_name,
            count=1,
            mining_time=1
        },
        remove_decoratives="true",
        heating_energy="50kW",
        energy_usage="1W",
        energy_source={ type="void" },
        crafting_speed=1,
        selection_box = {{-0.4, -0.4}, {0.4, 0.4}},
        collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
        collision_mask = {layers = {item = true, meltable = true, object = true, water_tile = true, is_object = true, is_lower_object = true}},
        flags={ "player-creation", "placeable-player", "placeable-neutral", "not-flammable" },
        tile_width=1,
        tile_height=1,
        crafting_categories={ cast_category_name },
        fast_replaceable_group = "casting"
    };

    local assembler_recipe = {
        name=form_name,
        type="recipe",
        localised_name=cooling_name,
        localised_decription=cooling_description,
        main_product=form_name,
        ingredients={
            { type="item", name="stone", amount=4 }
        },
        results={
            { type="item", name=form_name, amount=1 }
        },
        energy_required = 0.5,
        enabled = true,
        category="crafting"
    };

    local assembler_item = {
        name=form_name,
        type="item",
        localised_name=cooling_name,
        localised_decription=cooling_description,
        icons=icons,
        enabled = true,
        stack_size = data.raw.item.stone.weight / 4 + 1,
        weight = data.raw.item.stone.weight * 4,
        place_result=form_name
    };

    local cast_recipe = 
    {
        name=cast_recipe_name,
        type="recipe",
        localised_name=cooling_name,
        localised_decription=cooling_description,
        main_product=parameters.result.item,
        ingredients={
            { type="fluid", name=parameters.source.fluid, amount=parameters.source.amount, temperature=parameters.source.temperature }
        },
        results={
            { type="item", name=parameters.result.item, amount=parameters.result.amount }
        },
        energy_required = parameters.cooling_time,
        enabled = true,
        category="nauvis-cast-category"
    }

    return {
        assembler, assembler_recipe, assembler_item, cast_recipe
    }
end

data:extend{
    {
        name="forms",
        type="item-subgroup",
        group="production"
    },
    {
        name="nauvis-cast-category",
        type="recipe-category"
    }
};

require("prototypes.pipecovers")
require("prototypes.pipepictures")

local sounds = require("__base__/prototypes/entity/sounds")

data:extend{
    {
        name="nauvis-molten-channel",
        type="pipe",
        icon = "__base__/graphics/icons/stone.png",
        flags = {"placeable-neutral", "player-creation"},
        minable = {mining_time = 0.1, result = "nauvis-molten-channel"},
        selection_box = {{-0.4, -0.4}, {0.4, 0.4}},
        collision_box = {{-0.4, -0.4}, {0.4, 0.4}},
        collision_mask = {layers = {item = true, meltable = true, object = true, water_tile = true, is_object = true, is_lower_object = true}},
        fluid_box = {
            volume=1,
            pipe_covers=pipecoverspictures(),
            pipe_connections =
            {
              { direction = defines.direction.north, position = {0, 0}, connection_category="molten-channel" },
              { direction = defines.direction.east, position = {0, 0}, connection_category="molten-channel" },
              { direction = defines.direction.south, position = {0, 0}, connection_category="molten-channel" },
              { direction = defines.direction.west, position = {0, 0}, connection_category="molten-channel" }
            },
            hide_connection_info = true
        },
        pictures = pipepictures(),
        impact_category = "stone",
        working_sound = sounds.pipe,
        --open_sound = sounds.stone_small_,
        --close_sound = sounds.metal_small_close,
    
        horizontal_window_bounding_box = {{-0.25, -0.28125}, {0.25, 0.15625}},
        vertical_window_bounding_box = {{-0.28125, -0.5}, {0.03125, 0.125}}
    },
    {
        name="nauvis-molten-channel",
        type="recipe",
        main_product="nauvis-molten-channel",
        ingredients={
            { type="item", name="stone", amount=4 }
        },
        results={
            { type="item", name="nauvis-molten-channel", amount=1 }
        },
        energy_required = 0.5,
        enabled = true,
        category="crafting"
    },
    {
        name="nauvis-molten-channel",
        type="item",
        icons={
            { icon="__base__/graphics/icons/stone.png" },
        },
        enabled = true,
        stack_size = data.raw.item.stone.weight / 4 + 1,
        weight = data.raw.item.stone.weight * 4,
        place_result="nauvis-molten-channel"
    }
};

data:extend(stone_form{ planet="nauvis", cooling_time=48, source={ fluid="molten-iron", amount=10, temperature=iron_temperature }, result={ item="iron-plate", amount=1 } });
data:extend(stone_form{ planet="nauvis", cooling_time=96, source={ fluid="molten-iron", amount=20, temperature=iron_temperature }, result={ item="iron-gear-wheel", amount=1 } });
data:extend(stone_form{ planet="nauvis", cooling_time=64, source={ fluid="molten-iron", amount=10, temperature=iron_temperature }, result={ item="iron-stick", amount=2 } });
data:extend(stone_form{ planet="nauvis", cooling_time=32, source={ fluid="molten-copper", amount=10, temperature=copper_temperature }, result={ item="copper-plate", amount=1 } });
data:extend(stone_form{ planet="nauvis", cooling_time=16, source={ fluid="molten-copper", amount=5, temperature=copper_temperature }, result={ item="copper-cable", amount=1 } });