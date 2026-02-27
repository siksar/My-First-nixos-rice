{ config, pkgs, lib, ... }:

{
	# VIRTUALIZATION & GPU PASSTHROUGH
	virtualisation.libvirtd = {
		enable = true;
		qemu = {
			package = pkgs.qemu_kvm;
			runAsRoot = true;
			swtpm.enable = true;

		};
		onBoot = "ignore";
		onShutdown = "shutdown";
	};

	programs.virt-manager.enable = true;

	environment.systemPackages = with pkgs; [
		virt-manager
		qemu
		looking-glass-client
	];

	# Looking Glass Shared Memory
	systemd.tmpfiles.rules = [
		"f /dev/shm/looking-glass 0660 zixar kvm -"
	];

	# Enable IOMMU by default (doesn't hurt performance much, needed for mapping)
	boot.kernelParams = [ "amd_iommu=on" "iommu=pt" ];

}
