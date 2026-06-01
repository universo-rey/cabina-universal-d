# Recipes

Recipes are short repeatable operating patterns for local agents.

Default rule: recipe first, tool second, evidence third. If the recipe asks for a governed order, stop and prepare the order instead of executing live.

Source-first rule: prefer `SOURCE_TCU_registry.recipes.yaml`, `SOURCE_TCU_RECIPES_INDEX.csv`, and runtime prompt/eval sources before writing a new local recipe.
