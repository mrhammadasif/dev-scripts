export const basePath = process.env.EDWIRE_HOME || "../"

export const Services = {
  'svc-mgmtAggr': {
    path: `${basePath}/EG.HttpAggregators.Management`,
    repo: "EG.HttpAggregators.Management"
  },
  'svc-tenantAggr': {
    path: `${basePath}/EG.HttpAggregators.Tenant`,
    repo: "EG.HttpAggregators.Tenant"
  },
  'svc-identity': {
    path: `${basePath}/EG.Services.Identity`,
    repo: "EG.Services.Identity"
  },
  'svc-tenant': {
    path: `${basePath}/EG.Services.Tenant`,
    repo: "EG.Services.Tenant"
  },
  'svc-registration': {
    path: `${basePath}/EG.Services.Registration`,
    repo: "EG.Services.Registration"
  },
  'svc-application': {
    path: `${basePath}/EG.Services.Application`,
    repo: "EG.Services.Application"
  },
  'svc-dataSync': {
    path: `${basePath}/EG.Services.DataSync`,
    repo: "EG.Services.DataSync"
  },
  'svc-analytics': {
    path: `${basePath}/EG.Services.Analytics`,
    repo: "EG.Services.Analytics"
  },
  'svc-imageServer': {
    path: `${basePath}/EG.Services.ImageServer`,
    repo: "EG.Services.ImageServer"
  },
  'svc-dataSyncJobEngine': {
    path: `${basePath}/EG.Services.DataSync.JobEngine`,
    repo: "EG.Services.DataSync.JobEngine"
  },
  
  'svc-helmChart': {
    path: `${basePath}/EG.HelmChart`,
    repo: "EG.HelmChart"
  },
  'svc-edFiOdsApi': {
    path: `${basePath}/EG.Services.EdFi.OdsApi`,
    repo: "EG.Services.EdFi.OdsApi"
  },
  'svc-edFiImsAdminService': {
    path: `${basePath}/EG.Services.IMSAdmin`,
    repo: "EG.Services.IMSAdmin"
  },

}

export const Apps = {
  common: {
    path: `${basePath}/EdGraph.Common.Web`,
    repo: "EG.Common.Web"
  },
  admin: {
    path: `${basePath}/EG.Applications.Admin/src/EdGraph.Applications.Admin.Web`,
    repo: "EG.Applications.Admin"
  },
  launcher: {
    path: `${basePath}/EG.Applications.Launcher/src/EdGraph.Applications.Launcher.Web`,
    repo: "EG.Applications.Launcher"
  },
  analytics: {
    path: `${basePath}/EG.Applications.Analytics/src/EdGraph.Applications.Analytics.Web`,
    repo: "EG.Applications.Analytics"
  },
  datasync: {
    path: `${basePath}/EG.Applications.DataSync/src/EdGraph.Applications.DataSync.Web`,
    repo: "EG.Applications.DataSync"
  },
  edfiadmin: {
    path: `${basePath}/EG.Applications.EdFi.Admin/src/EdGraph.Applications.EdFi.Admin.Web`,
    repo: "EG.Applications.EdFi.Admin"
  },
  validation: {
    path: `${basePath}/EG.Applications.Validations/src/EdGraph.Applications.Validations.Web`,
    repo: "EG.Applications.Validations"
  },
  partner: {
    path: `${basePath}/EG.Applications.Partner/src/EdGraph.Applications.Partner.Web`,
    repo: "EG.Applications.Partner"
  },
  mgmt: {
    path: `${basePath}/EG.Applications.Management/src/EdGraph.Applications.Management.Web`,
    repo: "EG.Applications.Management"
  },
  statereport: {
    path: `${basePath}/EG.Applications.StateReporting/src/EdGraph.Applications.StateReporting.Web`,
    repo: "EG.Applications.StateReporting"
  },
  imsadmin: {
    path: `${basePath}/EG.Applications.IMSAdmin/src/EdGraph.Applications.IMSAdmin.Web`,
    repo: "EG.Applications.IMSAdmin"
  }
}

export const AppNames = Object.keys( Apps )
export const ServiceNames = Object.keys( Services )
export const Repos = { ...Apps, ...Services }
export const RepoNames = [ ...AppNames, ...ServiceNames ]