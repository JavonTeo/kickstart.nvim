<!--
  SramVisualization Component
  
  Main SRAM (Static Random Access Memory) visualization component that displays
  memory data in a grid format with interactive features.
  
  Features include:
  - Interactive grid with hover tooltips
  - Error handling with retry functionality
  - Loading states with spinner
  - Cell tooltips with detailed information
  - Responsive design with dark theme
  
  Dependencies:
  - SramGrid for the main data display
  - CellTooltip for hover information
  - Common components (ErrorMessage, LoadingSpinner)
  - SRAM store for data management
  
  Usage:
  <SramVisualization title="Weight Region" regionType="weight" />
-->
<template>
  <div class="sram-container">
    <!-- Error display with retry functionality -->
    <ErrorMessage
      v-if="error"
      :message="error"
      :show-retry="true"
      @retry="fetchSramData"
    />

    <!-- Loading indicator while fetching data -->
    <LoadingSpinner
      v-if="loading"
      message="Loading SRAM data..."
    />

    <!-- Main SRAM grid display -->
    <SramGrid
      v-else-if="weightData.length > 0"
      :data="weightData"
      @cell-hover="showCellDetails"
      @cell-leave="hideCellDetails"
      :title="title"
    />

    <!-- No data message with retry option -->
    <ErrorMessage
      v-else
      message="No SRAM data available. Click 'Retry' to load data."
      :show-retry="true"
      @retry="fetchSramData"
    />

    <!-- Cell tooltip for hover information -->
    <CellTooltip
      v-if="showTooltip"
      :data="tooltipData"
      :position="{ x: tooltipX, y: tooltipY }"
    />
  </div>
</template>

<script>
import SramGrid from './SramGrid.vue'
import CellTooltip from './CellTooltip.vue'
import ErrorMessage from '../common/ErrorMessage.vue'
import LoadingSpinner from '../common/LoadingSpinner.vue'
import { useSramStore } from '../../stores/sram'
import { storeToRefs } from 'pinia'

export default {
  name: 'SramVisualization',
  components: {
    SramGrid,
    CellTooltip,
    ErrorMessage,
    LoadingSpinner
  },
  setup() {
    // Initialize SRAM store for data management
    const sramStore = useSramStore()
    const { weightData, fmData, error, loading, numRows } = storeToRefs(sramStore)

    return {
      // State from store
      weightData,
	fmData,
      error,
      loading,
      numRows,
      
      // Actions from store
      fetchSramData: sramStore.fetchSramData
    }
  },
  data() {
    return {
      // Tooltip state for cell hover information
      showTooltip: false,
      tooltipX: 0,
      tooltipY: 0,
      tooltipData: {}
    }
  },
  methods: {
    /**
     * Show cell details tooltip on hover
     * @param {Object} cellInfo - Cell information (row, col, value)
     */
    showCellDetails(cellInfo) {
      const element = event.target
      const rect = element.getBoundingClientRect()
      
      this.tooltipData = cellInfo
      this.tooltipX = rect.right + 10
      this.tooltipY = rect.top
      this.showTooltip = true
    },
    
    /**
     * Hide cell details tooltip
     */
    hideCellDetails() {
      this.showTooltip = false
    }
  },
  async created() {
    // Always fetch data when component is created
    await this.fetchSramData(true)
  },
  watch: {
    // Watch for when the SRAM tab becomes active
    '$parent.activeTab': {
      handler(newTab) {
        if (newTab === 'sram-memory' && !this.weightData.length) {
          // only fetch when the SRAM tab is active and weightData is not available
          this.fetchSramData()
        }
      },
      immediate: true
    }
  },
  props: {
    // Title displayed in the SRAM grid
    title: {
      type: String,
      required: true
    }
  }
}
</script>

<style scoped>
/* Main SRAM container with dark theme and monospace font */
.sram-container {
  padding: 0 0 40px 0;
  background: #1e1e1e;
  color: #d4d4d4;
  font-family: 'Consolas', monospace;
  height: 100%;
  display: flex;
  flex-direction: column;
  width: 100%;
  position: relative;
  overflow: hidden;
}
</style> 
