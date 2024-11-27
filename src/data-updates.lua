
data.raw.recipe["iron-plate"] = nil;
data:extend{
    {
        type="recipe",
        name="molten-iron-simple",
        icon="__space-age__/graphics/icons/fluid/molten-iron.png",
        category="smelting",
        energy_required=5,
        ingredients={
            { type="item", name="iron-ore", amount=5 }
        },
        results={
            { type="fluid", name="molten-iron", amount=50, temperature=2000 }
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
            }
        },
    }
}

local function stone_form(planet, cooling_time, cooled, source, source_count, result, result_count)
    local icons = {
        { icon="__base__/graphics/icons/stone.png" },
        { icon="__base__/graphics/icons/"..result..".png" },
    }
    local form_name = planet .. "-" .. result .. "-cast-form";
    local form_item_name = form_name .. "-item";
    local form_recipe_name = form_name .. "-recipe";
    local cast_recipe_name = planet .. "-" .. result .. "-cast-recipe";
    local cast_category_name = planet .. "-cast-category";

    local assembler = {
        name=form_name,
        localised_name={"entity-name.form", {"item-name." .. result}, {"fluid-name."..source}},
        localised_decription={"entity-description.cooling", {"item-name." .. result}, {"fluid-name."..source}},
        type="assembling-machine",
        icons=icons,
        ingredient_count=1, --resource and coolant
        fluid_boxes = {
            {
                volume=source_count,
                production_type="input",
                pipe_connections={
                    {
                        connection_type="normal", 
                        flow_direction="input",
                        direction=defines.direction.west,
                        position={x=0,y=0},
                    }
                },
            }
        },
        fixed_recipe=cast_recipe_name,
        hidden = false,
        subgroup = "forms",
        placeable_by={
            item=form_item_name,
            count=1
        },
        minable={
            result=form_item_name,
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
        name=form_recipe_name,
        type="recipe",
        localised_name={"entity-name.form", {"item-name." .. result}, {"fluid-name."..source}},
        localised_decription={"entity-description.cooling", {"item-name." .. result}, {"fluid-name."..source}},
        main_product=form_item_name,
        ingredients={
            { type="item", name="stone", amount=4 }
        },
        results={
            { type="item", name=form_item_name, amount=1 }
        },
        energy_required = 0.5,
        enabled = true,
        category="crafting"
    };

    local assembler_item = {
        name=form_item_name,
        type="item",
        localised_name={"entity-name.form", {"item-name." .. result}, {"fluid-name."..source}},
        localised_decription={"entity-description.cooling", {"item-name." .. result}, {"fluid-name."..source}},
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
        localised_name={"entity-name.form", {"item-name." .. result}, {"fluid-name."..source}},
        localised_decription={"entity-description.cooling", {"item-name." .. result}, {"fluid-name."..source}},
        main_product=result,
        ingredients={
            { type="fluid", name=source, amount=source_count, temperature=2000 }
        },
        results={
            { type="item", name=result, amount=result_count }
        },
        energy_required = cooling_time,
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

data:extend(stone_form("nauvis", 96, false, "molten-iron", 10, "iron-plate", 1));
data:extend(stone_form("nauvis", 48, false, "molten-iron", 20, "iron-gear-wheel", 1));
data:extend(stone_form("nauvis", 64, false, "molten-iron", 10, "iron-stick", 2));