#pragma once

#include <chrono>
#include <cstdint>

namespace hydra {

// Monotonic nanoseconds provide portable profiling units on all host CPUs.
inline std::uint64_t hostClockTicks() {
    return static_cast<std::uint64_t>(std::chrono::duration_cast<std::chrono::nanoseconds>(
        std::chrono::steady_clock::now().time_since_epoch()).count());
}

}  // namespace hydra
