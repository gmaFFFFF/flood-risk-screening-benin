import matplotlib.pyplot as plt
import numpy as np

# Input statistics
x_min = 115.4
x_max = 499.8
mean = 208.9
std = 50.7
a = 1.0  # Mean multiplier
b = 1.0  # Std multiplier

# Evaluation scale
scale_from = 1
scale_to = 5

def ms_large(x, m, s, a, b):
    threshold = a * m
    denominator = x - threshold + (b * s)
    # Avoid division by zero and handle values below threshold
    res = np.where(x > threshold, 1 - (b * s) / denominator, 0)
    return res

# Generate X values
x = np.linspace(x_min, x_max, 500)
f_x = ms_large(x, mean, std, a, b)

# Rescale to 1-5
y = f_x * (scale_to - scale_from) + scale_from

# Plotting
plt.figure(figsize=(8, 5))
plt.plot(x, y, color='red', linewidth=2, label='MSLarge (M=1, S=1)')
plt.axvline(mean, color='gray', linestyle='--', label=f'Mean ({mean:.1f})')
plt.axvline(mean + std, color='lightgray', linestyle=':', label=f'Mean + 1 Std ({mean+std:.1f})')

plt.title('Аппроксимация функции нормализации Hazard (MSLarge)')
plt.xlabel('Исходное значение (Интегральный индекс)')
plt.ylabel('Балл риска (1-5)')
plt.grid(True, which='both', linestyle='--', alpha=0.5)
plt.legend()
plt.ylim(0.5, 5.5)

# Annotate thresholds
plt.text(mean, 0.7, 'Threshold', horizontalalignment='center', color='gray', fontsize=9)

# Save the plot
output_path = r'workspace\result\prepare\artifacts\hazard_approx.png'
plt.savefig(output_path, dpi=150, bbox_inches='tight')
print(f'Successfully saved plot to {output_path}')
