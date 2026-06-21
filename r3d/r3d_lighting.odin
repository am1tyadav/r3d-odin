/* r3d_lighting.odin -- R3D Lighting Module.
 *
 * Copyright (c) 2025-2026 Le Juez Victor
 *
 * This software is provided 'as-is', without any express or implied warranty.
 * For conditions of distribution and use, see accompanying LICENSE file.
 */
package r3d

import rl "vendor:raylib"

when ODIN_OS == .Windows {
    foreign import lib {
        "windows/r3d.lib",
    }
} else when ODIN_OS == .Linux {
    foreign import lib {
        "linux/libr3d.a",
    }
} else when ODIN_OS == .Darwin {
    foreign import lib {
        "/macos/libr3d.a",
    }
}

/**
 * @brief Types of lights supported by the rendering engine.
 *
 * Each light type has different behaviors and use cases.
 */
LightType :: enum u32 {
    DIR        = 0, ///< Directional light, affects the entire scene with parallel rays.
    SPOT       = 1, ///< Spot light, emits light in a cone shape.
    OMNI       = 2, ///< Omni light, emits light in all directions from a single point.
    TYPE_COUNT = 3,
}

/**
 * @brief Modes for updating shadow maps.
 *
 * Determines how often the shadow maps are refreshed.
 */
ShadowUpdateMode :: enum u32 {
    MANUAL     = 0, ///< Shadow maps update only when explicitly requested.
    INTERVAL   = 1, ///< Shadow maps update at defined time intervals.
    CONTINUOUS = 2, ///< Shadow maps update every frame for real-time accuracy.
}

/**
 * @brief Unique identifier for an R3D light.
 *
 * ID type used to reference a light.
 * A negative value indicates an invalid light.
 */
Light :: i32

@(default_calling_convention="c", link_prefix="R3D_")
foreign lib {
    /**
     * @brief Creates a new light of the specified type.
     *
     * This function creates a light of the given type. The light must be destroyed
     * manually when no longer needed by calling `R3D_DestroyLight`.
     *
     * @param type The type of light to create (directional, spot or omni-directional).
     * @return The ID of the created light.
     */
    CreateLight :: proc(type: LightType) -> Light ---

    /**
     * @brief Destroys the specified light.
     *
     * This function deallocates the resources associated with the light and makes
     * the light ID invalid. It must be called after the light is no longer needed.
     *
     * @param id The ID of the light to destroy.
     */
    DestroyLight :: proc(id: Light) ---

    /**
     * @brief Checks if a light exists.
     *
     * This function checks if the specified light ID is valid and if the light exists.
     *
     * @param id The ID of the light to check.
     * @return True if the light exists, false otherwise.
     */
    IsLightValid :: proc(id: Light) -> bool ---

    /**
     * @brief Gets the type of a light.
     *
     * This function returns the type of the specified light (directional, spot or omni-directional).
     *
     * @param id The ID of the light.
     * @return The type of the light.
     */
    GetLightType :: proc(id: Light) -> LightType ---

    /**
     * @brief Returns whether a light is currently enabled.
     *
     * @param id The ID of the light to query.
     * @return True if the light is enabled, false otherwise.
     */
    IsLightEnabled :: proc(id: Light) -> bool ---

    /**
     * @brief Toggles a light between enabled and disabled states.
     *
     * @param id The ID of the light to toggle.
     */
    ToggleLight :: proc(id: Light) ---

    /**
     * @brief Enables a light.
     *
     * Has no effect if the light is already enabled.
     *
     * @param id The ID of the light to enable.
     */
    EnableLight :: proc(id: Light) ---

    /**
     * @brief Disables a light.
     *
     * Has no effect if the light is already disabled.
     *
     * @param id The ID of the light to disable.
     */
    DisableLight :: proc(id: Light) ---

    /**
     * @brief Gets the color of a light.
     *
     * This function retrieves the color of the specified light as a `rl.Color` structure.
     *
     * @param id The ID of the light.
     * @return The color of the light as a `rl.Color` structure.
     */
    GetLightColor :: proc(id: Light) -> rl.Color ---

    /**
     * @brief Gets the color of a light as a `rl.Vector3`.
     *
     * This function retrieves the color of the specified light as a `rl.Vector3`, where each
     * component (x, y, z) represents the RGB values of the light.
     *
     * @param id The ID of the light.
     * @return The color of the light as a `rl.Vector3`.
     */
    GetLightColorV :: proc(id: Light) -> rl.Vector3 ---

    /**
     * @brief Sets the color of a light.
     *
     * This function sets the color of the specified light using a `rl.Color` structure.
     *
     * @param id The ID of the light.
     * @param color The new color to set for the light.
     */
    SetLightColor :: proc(id: Light, color: rl.Color) ---

    /**
     * @brief Sets the color of a light using a `rl.Vector3`.
     *
     * This function sets the color of the specified light using a `rl.Vector3`, where each
     * component (x, y, z) represents the RGB values of the light.
     *
     * @param id The ID of the light.
     * @param color The new color to set for the light as a `rl.Vector3`.
     */
    SetLightColorV :: proc(id: Light, color: rl.Vector3) ---

    /**
     * @brief Gets the position of a light.
     *
     * This function retrieves the position of the specified light.
     * Only applicable to spot lights or omni-lights.
     *
     * @param id The ID of the light.
     * @return The position of the light as a `rl.Vector3`.
     */
    GetLightPosition :: proc(id: Light) -> rl.Vector3 ---

    /**
     * @brief Sets the position of a light.
     *
     * This function sets the position of the specified light.
     * Only applicable to spot lights or omni-lights.
     *
     * @note Has no effect for directional lights.
     *       If called on a directional light,
     *       a warning will be logged.
     *
     * @param id The ID of the light.
     * @param position The new position to set for the light.
     */
    SetLightPosition :: proc(id: Light, position: rl.Vector3) ---

    /**
     * @brief Gets the direction of a light.
     *
     * This function retrieves the direction of the specified light.
     * Only applicable to directional lights or spot lights.
     *
     * @param id The ID of the light.
     * @return The direction of the light as a `rl.Vector3`.
     */
    GetLightDirection :: proc(id: Light) -> rl.Vector3 ---

    /**
     * @brief Sets the direction of a light.
     *
     * This function sets the direction of the specified light.
     * Only applicable to directional lights or spot lights.
     *
     * @note Has no effect for omni-directional lights.
     *       If called on an omni-directional light,
     *       a warning will be logged.
     *
     * @param id The ID of the light.
     * @param direction The new direction to set for the light.
     *                  The vector is automatically normalized.
     */
    SetLightDirection :: proc(id: Light, direction: rl.Vector3) ---

    /**
     * @brief Sets the position and direction of a light to look at a target point.
     *
     * This function sets both the position and the direction of the specified light,
     * causing it to "look at" a given target point.
     *
     * @note - For directional lights, only the direction is updated (position is ignored).
     *       - For omni-directional lights, only the position is updated (direction is not calculated).
     *       - For spot lights, both position and direction are set accordingly.
     *       - This function does **not** emit any warning or log message.
     *
     * @param id The ID of the light.
     * @param position The position to set for the light.
     * @param target The point the light should look at.
     */
    SetLightTarget :: proc(id: Light, position: rl.Vector3, target: rl.Vector3) ---

    /**
     * @brief Gets the energy level of a light.
     *
     * This function retrieves the energy level (intensity) of the specified light.
     * Energy typically affects the brightness of the light.
     *
     * @param id The ID of the light.
     * @return The energy level of the light.
     */
    GetLightEnergy :: proc(id: Light) -> f32 ---

    /**
     * @brief Sets the energy level of a light.
     *
     * This function sets the energy (intensity) of the specified light.
     * A higher energy value will result in a brighter light.
     *
     * @param id The ID of the light.
     * @param energy The new energy value to set for the light.
     */
    SetLightEnergy :: proc(id: Light, energy: f32) ---

    /**
     * @brief Gets the specular intensity of a light.
     *
     * This function retrieves the current specular intensity of the specified light.
     * Specular intensity affects how shiny surfaces appear when reflecting the light.
     *
     * @param id The ID of the light.
     * @return The current specular intensity of the light.
     */
    GetLightSpecular :: proc(id: Light) -> f32 ---

    /**
     * @brief Sets the specular intensity of a light.
     *
     * This function sets the specular intensity of the specified light.
     * Higher specular values result in stronger and sharper highlights on reflective surfaces.
     *
     * @param id The ID of the light.
     * @param specular The new specular intensity value to set for the light.
     */
    SetLightSpecular :: proc(id: Light, specular: f32) ---

    /**
     * @brief Gets the range of a light.
     *
     * This function retrieves the range of the specified light, which determines how far the light can affect.
     * Only applicable to spot lights or omni-lights.
     *
     * @param id The ID of the light.
     * @return The range of the light.
     */
    GetLightRange :: proc(id: Light) -> f32 ---

    /**
     * @brief Sets the range parameter of a light.
     *
     * For spot and omni lights, this defines the maximum illumination distance.
     * For directional lights, this defines the shadow rendering radius around the camera.
     *
     * @param id The ID of the light.
     * @param range The range value to apply.
     */
    SetLightRange :: proc(id: Light, range: f32) ---

    /**
     * @brief Gets the falloff exponent of a light.
     *
     * Controls the shape of the attenuation curve over the light's range.
     * A value of 1.0 produces a linear falloff, 2.0 a quadratic (more physically
     * plausible) falloff, and higher values concentrate the light closer to the source.
     * Only applicable to spot lights and omni-lights.
     *
     * @param id The ID of the light.
     * @return The falloff exponent of the light.
     */
    GetLightFalloff :: proc(id: Light) -> f32 ---

    /**
     * @brief Sets the falloff exponent of a light.
     *
     * Controls the shape of the attenuation curve over the light's range.
     * A value of 1.0 produces a linear falloff, 2.0 a quadratic (more physically
     * plausible) falloff, and higher values concentrate the light closer to the source.
     * Values of 0.0 or below are clamped to 1.0.
     * Only applicable to spot lights and omni-lights.
     *
     * @param id The ID of the light.
     * @param falloff The falloff exponent to set. Typical range is [0.5, 4.0].
     */
    SetLightFalloff :: proc(id: Light, falloff: f32) ---

    /**
     * @brief Gets the inner and outer cone angles of a spot light.
     *
     * The inner angle defines the region of full intensity, and the outer angle
     * defines where the light fully fades out. The transition between the two
     * produces a soft edge. Both angles are in degrees.
     * Only applicable to spot lights.
     *
     * @param id The ID of the light.
     * @param inner Pointer to receive the inner cone angle, in degrees. May be NULL.
     * @param outer Pointer to receive the outer cone angle, in degrees. May be NULL.
     */
    GetLightAngle :: proc(id: Light, inner: ^f32, outer: ^f32) ---

    /**
     * @brief Sets the inner and outer cone angles of a spot light.
     *
     * The inner angle defines the region of full intensity, and the outer angle
     * defines where the light fully fades out. The transition between the two
     * produces a soft edge. Both angles are in degrees. If inner exceeds outer,
     * the two values are swapped automatically.
     * Only applicable to spot lights.
     *
     * @param id The ID of the light.
     * @param inner The inner cone half-angle, in degrees.
     * @param outer The outer cone half-angle, in degrees.
     */
    SetLightAngle :: proc(id: Light, inner: f32, outer: f32) ---

    /**
     * @brief Enables shadow rendering for a light.
     *
     * Turns on shadow rendering for the light. The engine will allocate a shadow
     * map if needed, or reuse one previously allocated for another light.
     *
     * Shadow map resolutions are fixed: 2048x2048 for spot and point lights,
     * and 4096x4096 for directional lights.
     *
     * @param id The ID of the light.
     *
     * @note Creating too many shadow-casting lights can exhaust GPU memory and
     * potentially crash the graphics driver. Disabling shadows on one light and
     * enabling them on another is free, since existing shadow maps are reused.
     */
    EnableShadow :: proc(id: Light) ---

    /**
     * @brief Disables shadow rendering for a light.
     *
     * Turns off shadow rendering for the light. The associated shadow map is
     * kept in memory and may later be reused by another light.
     *
     * @param id The ID of the light.
     */
    DisableShadow :: proc(id: Light) ---

    /**
     * @brief Checks if shadow casting is enabled for a light.
     *
     * This function checks if shadow casting is currently enabled for the specified light.
     *
     * @param id The ID of the light.
     * @return True if shadow casting is enabled, false otherwise.
     */
    IsShadowEnabled :: proc(id: Light) -> bool ---

    /**
     * @brief Gets the shadow map update mode of a light.
     *
     * This function retrieves the current mode for updating the shadow map of a light. The mode can be:
     * - Interval: Updates the shadow map at a fixed interval.
     * - Continuous: Updates the shadow map continuously.
     * - Manual: Updates the shadow map manually (via explicit function calls).
     *
     * @param id The ID of the light.
     * @return The shadow map update mode.
     */
    GetShadowUpdateMode :: proc(id: Light) -> ShadowUpdateMode ---

    /**
     * @brief Sets the shadow map update mode of a light.
     *
     * This function sets the mode for updating the shadow map of the specified light.
     * The update mode controls when and how often the shadow map is refreshed.
     *
     * @param id The ID of the light.
     * @param mode The update mode to set for the shadow map (Interval, Continuous, or Manual).
     */
    SetShadowUpdateMode :: proc(id: Light, mode: ShadowUpdateMode) ---

    /**
     * @brief Gets the interval between shadow map updates in interval update mode.
     *
     * Only relevant when the shadow update mode is set to @ref R3D_SHADOW_UPDATE_INTERVAL.
     *
     * @param id The ID of the light.
     * @return The interval in seconds between shadow map updates.
     */
    GetShadowUpdateInterval :: proc(id: Light) -> f32 ---

    /**
     * @brief Sets the interval between shadow map updates in interval update mode.
     *
     * Only relevant when the shadow update mode is set to @ref R3D_SHADOW_UPDATE_INTERVAL.
     *
     * @param id The ID of the light.
     * @param seconds The interval in seconds between shadow map updates.
     */
    SetShadowUpdateInterval :: proc(id: Light, seconds: f32) ---

    /**
     * @brief Forces an immediate update of the shadow map during the next rendering pass.
     *
     * This function forces the shadow map of the specified light to be updated during the next call to `R3D_End`.
     * This is primarily used for the manual update mode, but may also work for the interval mode.
     *
     * @param id The ID of the light.
     */
    UpdateShadowMap :: proc(id: Light) ---

    /**
     * @brief Retrieves the softness radius used to simulate penumbra in shadows.
     *
     * The softness is expressed as a sampling radius in texels within the shadow map.
     *
     * @param id The ID of the light.
     * @return The softness radius in texels currently set for the shadow.
     */
    GetShadowSoftness :: proc(id: Light) -> f32 ---

    /**
     * @brief Sets the softness radius used to simulate penumbra in shadows.
     *
     * This function adjusts the softness of the shadow edges for the specified light.
     * The softness value corresponds to a number of texels in the shadow map, independent
     * of its resolution. Larger values increase the blur radius, resulting in softer,
     * more diffuse shadows, while smaller values yield sharper shadows.
     *
     * @param id The ID of the light.
     * @param softness The softness radius in texels to apply (must be >= 0).
     *
     * @note The softness must be set only after shadows have been enabled for the light,
     *       since the shadow map resolution must be known before the softness can be applied.
     */
    SetShadowSoftness :: proc(id: Light, softness: f32) ---

    /**
     * @brief Retrieves the shadow opacity for a light.
     *
     * @param id The ID of the light.
     * @return The current shadow opacity.
     */
    GetShadowOpacity :: proc(id: Light) -> f32 ---

    /**
     * @brief Sets the shadow opacity for a light.
     *
     * The opacity controls the visual strength of shadows. A value of 0 makes shadows
     * fully transparent, while 1 applies full opacity. Values are not clamped, but the
     * usual range is 0 to 1.
     *
     * When the opacity is exactly 0, the light still owns its shadow map, but shadow
     * map rendering and shadow application are entirely skipped.
     *
     * @param id The ID of the light.
     * @param opacity The shadow opacity to apply.
     */
    SetShadowOpacity :: proc(id: Light, opacity: f32) ---

    /**
     * @brief Gets the shadow depth bias value.
     */
    GetShadowDepthBias :: proc(id: Light) -> f32 ---

    /**
     * @brief Sets the shadow depth bias value.
     *
     * A higher bias helps reduce "shadow acne" artifacts
     * (shadows flickering or appearing misaligned on surfaces).
     * Be careful: too large values may cause shadows to look detached
     * or floating away from objects.
     */
    SetShadowDepthBias :: proc(id: Light, value: f32) ---

    /**
     * @brief Gets the shadow slope bias value.
     */
    GetShadowSlopeBias :: proc(id: Light) -> f32 ---

    /**
     * @brief Sets the shadow slope bias value.
     *
     * This bias mainly compensates artifacts on surfaces angled
     * relative to the light. It helps prevent shadows from
     * incorrectly appearing or disappearing along object edges.
     */
    SetShadowSlopeBias :: proc(id: Light, value: f32) ---

    /**
     * @brief Gets the shadow caster mask.
     */
    GetShadowCasterMask :: proc(id: Light) -> Layer ---

    /**
     * @brief Replaces the shadow caster mask.
     */
    SetShadowCasterMask :: proc(id: Light, cullMask: Layer) ---

    /**
     * @brief Enables one or more layers in the shadow caster mask.
     */
    EnableShadowCasterLayers :: proc(id: Light, layerMask: Layer) ---

    /**
     * @brief Disables one or more layers from the shadow caster mask.
     */
    DisableShadowCasterLayers :: proc(id: Light, layerMask: Layer) ---

    /**
     * @brief Toggles one or more layers in the shadow caster mask.
     */
    ToggleShadowCasterLayers :: proc(id: Light, layerMask: Layer) ---

    /**
     * @brief Checks whether at least one object layer is visible to the shadow caster.
     */
    IsShadowCasterLayerVisible :: proc(id: Light, layerMask: Layer) -> bool ---

    /**
     * @brief Returns the bounding box encompassing the light's area of influence.
     *
     * This function computes the axis-aligned bounding box (AABB) that encloses the
     * volume affected by the specified light, based on its type:
     *
     * - For spotlights, the bounding box encloses the light cone.
     * - For omni-directional lights, it encloses a sphere representing the light's range.
     * - For directional lights, it returns an infinite bounding box to represent global influence.
     *
     * This bounding box is primarily useful for spatial partitioning, culling, or visual debugging.
     *
     * @param light The light for which to compute the bounding box.
     *
     * @return A rl.BoundingBox struct that encloses the light's influence volume.
     */
    GetLightBoundingBox :: proc(light: Light) -> rl.BoundingBox ---

    /**
     * @brief Draws the area of influence of the light in 3D space.
     *
     * This function visualizes the area affected by a light in 3D space.
     * It draws the light's influence, such as the cone for spotlights or the volume for omni-lights.
     * This function is only relevant for spotlights and omni-lights.
     *
     * @note This function should be called while using the default 3D rendering mode of raylib,
     *       not with R3D's rendering mode. It uses raylib's 3D drawing functions to render the light's shape.
     *
     * @param id The ID of the light.
     */
    DrawLightDebug :: proc(id: Light) ---
}

