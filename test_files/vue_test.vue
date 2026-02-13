<template>
	<div class="test-container">
		<h1>{{ title.toLowerCase() }}</h1>

		<p>Current Count: {{ count }}</p>

		<button @click="increment" :class="{ active: isMaxed }">
			Increment
		</button>

		<ul v-if="items.length > 0">
			<li v-for="item in items" :key="item.id">
				{{ item.label }}
			</li>
		</ul>
	</div>
</template>

<script setup lang="ts">
/** * Using lang="ts" is the best way to test if your LSP is working properly.
 * It forces the server to use TypeScript for background analysis.
 */
import { ref, computed } from 'vue';

// Define a strict interface to test deep object completion
interface ListItem {
	id: number;
	label: string;
}

const title = ref<string>("LSP Verification");
const count = ref(0);
const items = ref<ListItem[]>([
	{ id: 1, label: "Test Syntax" },
	{ id: 2, label: "Test Intelligence" }
]);

// 5. Computed Property Logic:
// Hover over 'isMaxed' to see if it correctly infers 'ComputedRef<boolean>'
const isMaxed = computed(() => count.value >= 10);

const increment = () => {
	count.value++;
};

// 6. Error Trigger for testing:
// Uncomment the line below. The LSP should highlight 'title' as a constant error.
// title.value = 123; 
</script>

<style scoped>
/* 7. CSS Completion: 
   Inside the brackets, type 'disp' to see if the LSP suggests 'display' */
.test-container {
	padding: 20px;
}
</style>
